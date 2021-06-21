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
  echo "usage: (ATTENTION: args order is important)"
  echo "build-rocm.sh [-c/--clean] [-a/--all] [-ct/--compile-tool]"
  echo "Options:"
  echo "-c/--clean:          Removes build directory before compiling (default: disabled)"
  echo "-a/--all:            Compile the whole ROCm stack (incompatible with -ct)" 
  echo "-ct/--compile-tool:  Compiles a specific tool (incompatible with -a)" 
}

declare -a TOOLS=("llvm-project" "rocm-cmake" "ROCm-Device-Libs" "ROCT-Thunk-Interface" "ROCR-Runtime" "ROCm-CompilerSupport" "ROCclr" "HIP" "rocminfo" "roctracer" "rocprofiler")
TARGET=()
CLEAN=false
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -a|--all)
      TARGET+=("${TOOLS[@]}")
      break
    ;;
    -c|--clean)
      CLEAN=true
      shift # past argument
    ;;
    -ct|--compile-tool)
      TARGET+=("${@:2}")
      break
    ;;
    *)    # unknown option
      usage
      exit -1
      break
    ;;
  esac
done

if [ -n "${TARGET}" ] ; then
  echo "INFO: compiling: ${TARGET[@]}"
fi
echo "INFO: clean flag is set to: ${CLEAN}"

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
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/rocm -DCMAKE_INSTALL_BINDIR=${INSTALL_DIR}/rocm/bin ..
  make -j
  make install
  cd ${cwd}
}

roctracer(){
  cd roctracer
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm" -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm -DHIP_VDI=1 ..
  make -j
  make install
  cd ${cwd}
}

rocprofiler(){
  cd rocprofiler
  if [ "$CLEAN" = true ] ; then
    clean;
  fi
  cd build
  CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/include/hsa;${INSTALL_DIR}/rocm" -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/rocprofiler -DCMAKE_INSTALL_BINDIR=${INSTALL_DIR}/rocm/bin ..
  make -j
  make install
  cd ${cwd}
}

print-all(){
  for i in "${TOOLS[@]}"
  do
    printf "%s, " "$i"
  done
  echo ""
}

for TOOL in "${TARGET[@]}"
do
  if [[ ! " ${TOOLS[@]} " =~ " ${TOOL} " ]]; then
    # whatever you want to do when array doesn't contain value
    echo "${TOOL} is not supported. Suported tools:"
    print-all
    exit -1
  fi
  printf "Compiling: %s ... " "$TOOL"
  eval "${TOOL} &> /tmp/${TOOL}_compile_log"
  if [ $? -eq 0 ]; then
    echo "successful"
  else
    echo "failed, check /tmp/${TOOL}_compile_log"	   
    exit 1
  fi
done

if [ ! -d "${INSTALL_DIR}/rocm/.info" ]; then
    mkdir ${INSTALL_DIR}/rocm/.info
    echo 4.1.2 > ${INSTALL_DIR}/rocm/.info/version
    echo 4.1.2 > ${INSTALL_DIR}/rocm/.info/version-dev
    echo 4.1.2 > ${INSTALL_DIR}/rocm/.info/version-utils
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
