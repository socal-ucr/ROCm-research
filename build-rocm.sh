#!/usr/bin/env bash

INSTALL_DIR=
cwd=$(pwd)

git submodule update --init --recursive 

cd amd-llvm-project/llvm/tools
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=1 -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" -DLLVM_ENABLE_PROJECTS="clang;lld" -DLLVM_INSTALL_UTILS=1 -G "Unix Makefiles" ../llvm
make -j
make install
cd ${cwd}

cd rocm-cmake
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm ..
cmake --build . --target install
cd ${cwd}

cd ROCT-Thunk-Interface
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm ..
make package
make install
cd ${cwd}

cd ROCR-Runtime/src
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm -DHSAKMT_INC_PATH=${INSTALL_DIR}/rocm/include -DHSAKMT_LIB_PATH=${INSTALL_DIR}/rocm/lib ..
make -j 
make install
cd ${cwd}

cd rocminfo
mkdir build && cd build
cmake -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/rocm  -DCMAKE_INSTALL_BINDIR=${INSTALL_DIR}/rocm/bin ..
make
make install
cd ${cwd}

cd ROCm-Device-Libs
mkdir build && cd build
CC=${INSTALL_DIR}/rocm/llvm/bin/clang CXX=${INSTALL_DIR}/rocm/llvm/bin/clang++ cmake -DCMAKE_PREFIX_PATH=${INSTALL_DIR}/rocm/llvm -DLLVM_DIR=${INSTALL_DIR}/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/rocdl ..
make -j
make install
cd ${cwd}

cd ROCm-CompilerSupport/lib/comgr
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/llvm;${INSTALL_DIR}/rocm/rocdl" -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/comgr ..
cd ${cwd}

ROCclr_DIR="$(readlink -f ROCclr)"
OPENCL_DIR="$(readlink -f ROCm-OpenCL-Runtime)"
cd ${ROCclr_DIR}
mkdir build && cd build
cmake -DOPENCL_DIR=${OPENCL_DIR} -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/rocclr ..
make -j
make install

cd ${OPENCL_DIR}
mkdir build && cd build
cmake -DUSE_COMGR_LIBRARY=ON -DCMAKE_PREFIX_PATH="${ROCclr_DIR}/build;${INSTALL_DIR}/rocm/" -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/opencl ..
make -j
make install
cd ${cwd}


cd HIP
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/rocm/hip -DHIP_COMPILER=clang -DCMAKE_BUILD_TYPE=Release -DHIP_PLATFORM=rocclr -DOPENCL_DIR=${INSTALL_DIR}/rocm/opencl -DCMAKE_PREFIX_PATH="${INSTALL_DIR}/rocm/rocclr;${INSTALL_DIR}/rocm/lib/cmake/hsa-runtime64/;${INSTALL_DIR}/rocm/comgr" -DHSA_PATH=${INSTALL_DIR}/rocm/hsa -DROCM_PATH=${INSTALL_DIR}/rocm ..
make -j
make install
