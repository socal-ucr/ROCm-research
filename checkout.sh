#!/usr/bin/env bash
set -e

cwd=$(pwd)

vHIP="rocm-4.1.x"
vHIP_Examples="rocm-4.1.x"
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
printf "HIP version:                  "
git checkout ${vHIP} &> /dev/null && printf "${vHIP}"
echo ""
cd ${cwd}

#HIP-Examples
cd HIP-Examples
printf "HIP-Examples version:         "
git checkout ${vHIP_Examples} &> /dev/null && printf "${vHIP_Examples}"
echo ""
cd ${cwd}

#ROCclr
cd ROCclr
printf "ROCclr version:               "
git checkout ${vROCclr} &> /dev/null && printf "${vROCclr}"
echo ""
cd ${cwd}

#ROCR-Runtime
cd ROCR-Runtime
printf "ROCR-Runtime version:         "
git checkout ${vROCR_Runtime} &> /dev/null && printf "${vROCm_OpenCL_Runtime}"
echo ""
cd ${cwd}

#ROCT-Thunk-Interface
cd ROCT-Thunk-Interface
printf "ROCT-Thunk-Interface version: "
git checkout ${vROCT_Thunk_Interface} &> /dev/null && printf "${vROCT_Thunk_Interface}"
echo ""
cd ${cwd}

#ROCm-CompilerSupport
cd ROCm-CompilerSupport
printf "ROCm-CompilerSupport version: "
git checkout ${vROCm_CompilerSupport} &> /dev/null && printf "${vROCm_CompilerSupport}"
echo ""
cd ${cwd}

#ROCm-Device-Libs
cd ROCm-Device-Libs
printf "ROCm-Device-Libs version:     "
git checkout ${vROCm_Device_Libs} &> /dev/null && printf "${vROCm_Device_Libs}"
echo ""
cd ${cwd}

#ROCm-OpenCL-Runtime
cd ROCm-OpenCL-Runtime
printf "ROCm-OpenCL-Runtime version:  "
git checkout ${vROCm_OpenCL_Runtime} &> /dev/null && printf "${vROCm_OpenCL_Runtime}"
echo ""
cd ${cwd}

#llvm-project
cd llvm-project
printf "llvm-project version:         "
git checkout ${vllvm_project} &> /dev/null && printf "${vllvm_project}"
echo ""
cd ${cwd}

#rocm-cmake
cd rocm-cmake
printf "rocm-cmake version:           "
git checkout ${vrocm_cmake} &> /dev/null && printf "${vrocm_cmake}"
echo ""
cd ${cwd}

#rocm_smi_lib
cd rocm_smi_lib
printf "rocm_smi_lib version:         "
git checkout ${vrocm_smi_lib} &> /dev/null && printf "${vrocm_smi_lib}"
echo ""
cd ${cwd}

#rocminfo
cd rocminfo
printf "rocminfo version:             "
git checkout ${vrocminfo} &> /dev/null && printf "${vrocminfo}"
echo ""
cd ${cwd}

#rocprofiler
cd rocprofiler
printf "rocprofiler version:          "
git checkout ${vrocprofiler} &> /dev/null && printf "${vrocprofiler}"
echo ""
cd ${cwd}