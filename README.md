use ` build-rocm.sh` to build the rocm stack from rock-thunk -> HIP

to use you need to set INSTALL_DIR and the following variables

```
ROCM_PATH=${INSTALL_DIR}/rocm
HIP_PATH=${ROCM_PATH}/hip
ROCM_TOOLKIT_PATH=${ROCM_PATH}
DEVICE_LIB_PATH=${ROCM_PATH}/rocdl/amdgcn/bitcode
PATH=${ROCM_PATH}/llvm/bin:${ROCM_PATH}/bin:${HIP_PATH}/bin:$PATH
LD_LIBRARY_PATH=${ROCM_PATH}/comgr/lib:${HIP_PATH}/lib:${ROCM_PATH}/rocrand/lib:${ROCM_PATH}/hiprand/lib:${ROCM_PATH}/lib:$LD_LIBRARY_PATH
GFXLIST="gfx906" 
```
