#!/usr/bin/env bash

cwd=$(pwd)

vHIP="rocm-4.1.x"
vROCclr="rocm-4.1.x"
vROCR_Runtime="rocm-4.1.x"
vROCT_Thunk_Interface="roc-4.1.x"
vROCm_CompilerSupport="roc-4.1.x"
vROCm_Device_Libs="roc-4.1.x"
vROCm_OpenCL_Runtime="rocm-4.1.x"
vllvm_project="roc-4.1.x"
vrocm_cmake="roc-4.0.x"
vrocm_smi_lib="release/rocm-rel-4.1"
vrocminfo="release/rocm-rel-4.1"
vrocprofiler="rocm-4.1.x"

#HIP
cd HIP
git checkout ${vHIP}
cd ${cwd}

#ROCclr
cd ROCclr
git checkout ${vROCclr}
cd ${cwd}

#ROCR-Runtime
cd ROCR-Runtime
git checkout ${vROCR_Runtime}
cd ${cwd}

#ROCT-Thunk-Interface
cd ROCT-Thunk-Interface
git checkout ${vROCT_Thunk_Interface}
cd ${cwd}

#ROCm-CompilerSupport
cd ROCm-CompilerSupport
git checkout ${vROCm_CompilerSupport}
cd ${cwd}

#ROCm-Device-Libs
cd ROCm-Device-Libs
git checkout ${vROCm_Device_Libs}
cd ${cwd}

#ROCm-OpenCL-Runtime
cd ROCm-OpenCL-Runtime
git checkout ${vROCm_OpenCL_Runtime}
cd ${cwd}

#llvm-project
cd llvm-project
git checkout ${vllvm_project}
cd ${cwd}

#rocm-cmake
cd rocm-cmake
git checkout ${vrocm_cmake}
cd ${cwd}

#rocm_smi_lib
cd rocm_smi_lib
git checkout ${vrocm_smi_lib}
cd ${cwd}

#rocminfo
cd rocminfo
git checkout ${vrocminfo}
cd ${cwd}

#rocprofiler
cd rocprofiler
git checkout ${vrocprofiler}
cd ${cwd}
