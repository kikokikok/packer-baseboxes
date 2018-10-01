#!/bin/bash -eux

cd ~/build
git clone https://github.com/iovisor/ply.git
cd ply
./autogen.sh
 export CFLAGS=-I${HOME}/build/usr/include
./configure
make
sudo make install

cd ..
curl -LO http://releases.llvm.org/3.9.1/cfe-3.9.1.src.tar.xz
curl -LO http://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz
tar -xf cfe-3.9.1.src.tar.xz
tar -xf llvm-3.9.1.src.tar.xz
mkdir clang-build
mkdir llvm-build

cd llvm-build
cmake3 -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ../llvm-3.9.1.src
make
sudo make install

cd ../clang-build
cmake3 -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ../cfe-3.9.1.src
make
sudo make install

cd ..
git clone https://github.com/iovisor/bcc.git
mkdir bcc-build
cd bcc-build
cmake3 -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr ../bcc
make
sudo make install