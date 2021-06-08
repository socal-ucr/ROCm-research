#!/usr/bin/env bash

cwd=$(pwd)

#HIP
cd HIP
git checkout rocm-4.1.x
cd ${cwd}

#ROCclr
cd ROCclr
git checkout rocm-4.1.x
cd ${cwd}

#ROCR-Runtime
cd ROCR-Runtime
git checkout rocm-4.1.x
cd ${cwd}

#ROCT-Thunk-Interface
cd ROCT-Thunk-Interface
git checkout roc-4.1.x
cd ${cwd}

#ROCm-CompilerSupport
cd ROCm-CompilerSupport
git checkout roc-4.1.x
cd ${cwd}

#ROCm-Device-Libs
cd ROCm-Device-Libs
git checkout roc-4.1.x
cd ${cwd}

#ROCm-OpenCL-Runtime
cd ROCm-OpenCL-Runtime
git checkout rocm-4.1.x
cd ${cwd}

#llvm-project
cd llvm-project
git checkout roc-4.1.x
cd ${cwd}

#rocm-cmake
cd rocm-cmake
git checkout roc-4.0.x
cd ${cwd}

#rocm_smi_lib
cd rocm_smi_lib
git checkout release/rocm-rel-4.1
cd ${cwd}

#rocminfo
cd rocminfo
git checkout release/rocm-rel-4.1
cd ${cwd}