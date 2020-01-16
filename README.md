  ```
0. packages

pkg-config
vim
build-essentials
libpci-dev
libnuma-dev
rpm
libelf-dev
doxygen
rename
z3
libxml2-dev
ocaml

0.1 ROCK-kernel
wget -qO - http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | sudo apt-key add -
echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main | sudo tee /etc/apt/sources.list.d/rocm.list
sudo apt-get update && sudo apt-get install rock-dkms hsa-ext-rocr-dev libhsa-ext-finalize64
sudo update-initramfs -u
sudo reboot


build rocm stack
1. llvm-project

cd llvm-project/llvm/tools
ln -s clang ../../clang
ln -s lld ../../lld
cd ../..
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=1 -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" -DLLVM_ENABLE_PROJECTS="clang;lld" -G "Unix Makefiles" ../llvm
make -j
sudo make install

2. rocm-cmake
cd rocm-cmake
mkdir build && cd build
cmake ..
sudo cmake --build . --target install

3. ROCT-Thunk-Interface
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/rocm ..
make package
make package-dev
sudo make install
sudo make install-dev

4. ROCR-Runtime
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFEX=/opt/rocm -DHSAKMT_INC_PATH=/opt/rocm/include -DHSAKMT_LIB_PATH=/opt/rocm/lib ..
make 
sudo make install

5. rocminfo
mkdir build && cd build
cmake -DCMAKE_PREFIX_PATH=/opt/rocm -DROCM_DIR=/opt/rocm -DCMAKE_INSTALL_BINDIR=/opt/rocm/bin ..
make
sudo make install

5. hcc
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j 16
sudo make install

6. Rocm-Device-Libs
export PATH=/opt/rocm/llvm/bin:$PATH
cd ROCm-Device-Libs
mkdir -p build && cd build
CC=clang CXX=clang++ cmake -DLLVM_DIR=/opt/rocm/llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WERROR=1 -DLLVM_ENABLE_ASSERTIONS=1 -DCMAKE_INSTALL_PREFIX=/opt/rocm/rocdl ..
make
sudo make install

7.ROCm-CompilierSupport
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_PREFIX_PATH="/opt/rocm/llvm;/opt/rocm/rocdl" -DCMAKE_INSTALL_PREFIX=/opt/rocm/comgr ..
make
sudo make install

8.HIP
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/rocm/hip -DHIP_COMPILER=clang -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/opt/rocm/comgr"
make -j 8

9. Compile Program
echo LD_LIBRARY_PATH=/opt/rocm/comgr/lib
$(HIPCC) --amdgpu-target=gfx900  -Wl,-rpath=/opt/rocm/lib -Wl,-rpath=/opt/rocm/hip/lib -Wl,-rpath=/opt/rocm/comgr/lib --hip-device-lib-path=/opt/rocm/rocdl/lib 
```  


