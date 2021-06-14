#!/usr/bin/env bash

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'if [ $? -ne 0 ]; then echo "\"${last_command}\" command failed with exit code $?."; fi;' EXIT;

INSTALL_DIR=${HOME}/.opt
cwd=$(pwd)

clean(){
  rm -rf build
  mkdir -p build 
}

usage(){
  echo "this script installs ROCm on ~/.opt/rocm"
  echo "usage:"
  echo "build-rocm.sh [-a/--all] [-c/--clean] [-ct/--compile-tool]"
  echo "Options:"
  echo "-a/--all:            Compile the whole ROCm stack (incompatible with -ct)" 
  echo "-c/--clean:          Removes build directory before compiling (default: disabled)"
  echo "-ct/--compile-tool:  Compiles a specific tool (incompatible with -a)" 
}

TARGET=""
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -a|--all)
      ALL=true
      shift # past argument
      if [ -n "${TARGET}" ]; then
	echo "Error: -a/--all and -ct/-compile-tool are set, see usage:"
	usage;
        exit 0;
      fi
    ;;
    -c|--clean)
      CLEAN=true
      shift # past argument
    ;;
    -ct|--compile-tool)
      TARGET="$2"
      if [ "$ALL" = true ] ; then
	echo "Error: -a/-all and -ct/--compile-tool are set, see usage:"
	usage;
        exit 0;
      fi
      shift # past argument
      shift # past value
    ;;
    *)    # unknown option
      usage
    ;;
  esac
done

if [ "$ALL" = true ] ; then
  echo "Compiling all directories"
fi
if [ -n "${TARGET}" ] ; then
  echo "Compiling: ${TARGET}"
fi
if [ "$CLEAN" = true ] ; then
  echo "Cleaning enabled"
fi


mkdir -p $INSTALL_DIR
#git submodule update --init --recursive

llvm-project(){
  cd llvm-project
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=1 -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" -DLLVM_ENABLE_PROJECTS="clang;lld;compiler-rt" -DLLVM_INSTALL_UTILS=1 -G "Unix Makefiles" ../llvm
  make -j
  make install
  cd ${cwd}
}

CC_DIR=${INSTALL_DIR}/rocm/llvm/bin/clang
CXX_DIR=${INSTALL_DIR}/rocm/llvm/bin/clang++

rocm-cmake(){
  cd rocm-cmake
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm ..
  cmake --build . --target install
  cd ${cwd}
}

ROCm-Device-Libs(){
  cd ROCm-Device-Libs
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/rocm/llvm -DLLVM_DIR=${INSTALL_DIR}/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/rocdl ..
  make -j
  make install
  cd ${cwd}
}

ROCT-Thunk-Interface(){
  cd ROCT-Thunk-Interface
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm ..
  make install
  cd ${cwd}
}

ROCR-Runtime(){
  cd ROCR-Runtime/src
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/include;${INSTALL_DIR}/rocm/lib;${INSTALL_DIR}/rocm/rocdl" -DCMAKE_CXX_FLAGS=-DNDEBUG ..
  make -j
  make install
  cd ${cwd}
}

ROCm-CompilerSupport(){
  cd ROCm-CompilerSupport/lib/comgr
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/llvm;${INSTALL_DIR}/rocm/rocdl" -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/comgr ..
  make -j
  make install
  cd ${cwd}
}


ROCclr_DIR="$(readlink -f ROCclr)"
OPENCL_DIR="$(readlink -f ROCm-OpenCL-Runtime)"
ROCclr(){
  cd ${ROCclr_DIR}
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/comgr" -DOPENCL_DIR=${OPENCL_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/rocclr ..
  make -j
  make install
  cd ${cwd}
}

HIP(){
  cd HIP
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/hip -DHIP_COMPILER=clang -DHIP_CLANG_PATH=${INSTALL_DIR}/rocm/llvm/bin -DCMAKE_BUILD_TYPE=Release -DHIP_PLATFORM=rocclr -DOPENCL_DIR=${INSTALL_DIR}/rocm/opencl -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/llvm;${ROCclr_DIR}/build;${INSTALL_DIR}/rocm/lib/cmake/hsa-runtime64;${INSTALL_DIR}/rocm/comgr;${INSTALL_DIR}/rocm" -DHSA_PATH=${INSTALL_DIR}/rocm/hsa -DROCM_PATH=${INSTALL_DIR}/rocm -DDEVICE_LIB_PATH=${INSTALL_PATH}/rocm.rocdl ..
  make -j
  make install
  cd ${cwd}
}

rocminfo(){
  cd rocminfo
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/rocm  -DCMAKE_INSTALL_BINDIR=${INSTALL_DIR}/rocm/bin ..
  make
  make install
  cd ${cwd}
}


declare -a TARGETS=("llvm-project" "rocm-cmake" "ROCm-Device-Libs" "ROCT-Thunk-Interface" "ROCR-Runtime" "ROCm-CompilerSupport" "ROCclr" "HIP" "rocminfo")
print-all(){
  for i in "${TARGETS[@]}"
  do
    printf "%s, " "$i"
  done
  echo ""
}

if [ -n "${TARGET}" ] ; then
  if [[ " ${TARGETS[@]} " =~ " ${TARGET} " ]]; then
    # whatever you want to do when array contains value
    TARGETS=("${TARGET}")
  else
    echo "${TARGET} is not valid, choose from the below list:"
    print-all
    exit 0
  fi
fi

for i in "${TARGETS[@]}"
do
  printf "Compiling: %s\n" "$i"
  eval "${i}"
  echo "${i} finished, cont?"
  read f
done

if [ ! -d "${INSTALL_DIR}/rocm/.info" ]; then
    mkdir ${INSTALL_DIR}/rocm/.info
    echo 4.1.1 > ${INSTALL_DIR}/rocm/.info/version
    echo 4.1.1 > ${INSTALL_DIR}/rocm/.info/version-dev
    echo 4.1.1 > ${INSTALL_DIR}/rocm/.info/version-utils
fi

if [ ! -d "${INSTALL_DIR}/rocm/include/hip" ]; then
    echo "LINKING hip/include/hip"
    ln -s ${INSTALL_DIR}/rocm/hip/include/hip ${INSTALL_DIR}/rocm/include/.
fi
if [ ! -f "${INSTALL_DIR}/rocm/bin/hipcc" ]; then
    echo "LINKING hip/bin/hipcc"
    ln -s ${INSTALL_DIR}/rocm/hip/bin/hipcc ${INSTALL_DIR}/rocm/bin/.
fi
if [ ! -f "${INSTALL_DIR}/rocm/lib/libamdhip64.so" ]; then
    echo "LINKING hip/lib/libamdhip64.so"
    ln -s ${INSTALL_DIR}/rocm/hip/lib/libamdhip64.so ${INSTALL_DIR}/rocm/lib/.
fi
