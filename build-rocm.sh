#!/usr/bin/env bash

INSTALL_DIR=/home/danwong/.opt 
cwd=$(pwd)

#git submodule update --init --recursive 

cd llvm-project
rm -rf build
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=1 -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" -DLLVM_ENABLE_PROJECTS="clang;lld;compiler-rt" -DLLVM_INSTALL_UTILS=1 -G "Unix Makefiles" ../llvm
make -j
make install
cd ${cwd}

CC_DIR=${INSTALL_DIR}/rocm/llvm/bin/clang
CXX_DIR=${INSTALL_DIR}/rocm/llvm/bin/clang++

cd rocm-cmake
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm ..
cmake --build . --target install
cd ${cwd}

cd ROCm-Device-Libs
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/rocm/llvm -DLLVM_DIR=${INSTALL_DIR}/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/rocdl ..
make -j
make install
cd ${cwd}

cd ROCT-Thunk-Interface
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm ..
make install
cd ${cwd}

cd ROCR-Runtime/src
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/include;${INSTALL_DIR}/rocm/lib;${INSTALL_DIR}/rocm/rocdl" ..
make -j 
make install
cd ${cwd}

cd ROCm-CompilerSupport/lib/comgr
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/llvm;${INSTALL_DIR}/rocm/rocdl" -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/comgr ..
make -j
make install
cd ${cwd}

ROCclr_DIR="$(readlink -f ROCclr)"
OPENCL_DIR="$(readlink -f ROCm-OpenCL-Runtime)"
cd ${ROCclr_DIR}
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/comgr" -DOPENCL_DIR=${OPENCL_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/rocclr ..
make -j
make install
cd ${cwd}

cd HIP
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/hip -DHIP_COMPILER=clang -DCMAKE_BUILD_TYPE=Release -DHIP_PLATFORM=rocclr -DOPENCL_DIR=${INSTALL_DIR}/rocm/opencl -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/llvm;${INSTALL_DIR}/rocm/rocclr;${INSTALL_DIR}/rocm/lib/cmake/hsa-runtime64/;${INSTALL_DIR}/rocm/comgr" -DHSA_PATH=${INSTALL_DIR}/rocm/hsa -DROCM_PATH=${INSTALL_DIR}/rocm ..
make -j
make install
cd ${cwd}

cd rocminfo
rm -rf build
mkdir build && cd build
CC=${CC_DIR} CXX=${CXX_DIR} cmake -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/rocm  -DCMAKE_INSTALL_BINDIR=${INSTALL_DIR}/rocm/bin ..
make
make install
cd ${cwd}

mkdir ${INSTALL_DIR}/rocm/.info
echo 4.0.0 > ${INSTALL_DIR}/rocm/.info/version
echo 4.0.0 > ${INSTALL_DIR}/rocm/.info/version-dev
echo 4.0.0 > ${INSTALL_DIR}/rocm/.info/version-utils

ln -s ${INSTALL_DIR}/rocm/hip/include/hip ${INSTALL_DIR}/rocm/include/.
ln -s ${INSTALL_DIR}/rocm/hip/bin/hipcc ${INSTALL_DIR}/rocm/bin/.
ln -s ${INSTALL_DIR}/rocm/hip/lib/libamdhip64.so ${INSTALL_DIR}/rocm/lib/.
