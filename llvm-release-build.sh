#! /bin/bash

# ./llvm-release-build.sh /Users/builder/llvm/llvm-src 9.0.0

GIT_REPO=$1
LLVM_REV=$2
BUILD_DIR=build_llvm-${LLVM_REV}
INSTALL_NAME=clang+llvm-${LLVM_REV}-arm64-apple-darwin
INSTALL_PATH=/usr/local/${INSTALL_NAME}

if [ "$LLVM_REV" != "current" ]; then
  (cd ${GIT_REPO} && git checkout llvmorg-${LLVM_REV})
else
  echo "Building current"
fi

mkdir -p ${BUILD_DIR}

cd ${BUILD_DIR}

cmake -G "Ninja" -DCMAKE_OSX_DEPLOYMENT_TARGET="13.0" -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} -DCMAKE_BUILD_TYPE=MinSizeRel -DLLVM_INCLUDE_EXAMPLES=0 -DLLVM_INCLUDE_TESTS=0 -DLLVM_ENABLE_ZSTD=Off -DLLVM_ENABLE_PROJECTS="clang" -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" -DCMAKE_CXX_STANDARD=20 ${GIT_REPO}/llvm

cmake --build .

umask 002
sudo mkdir -p ${INSTALL_PATH}
sudo chmod 0777 ${INSTALL_PATH}
ninja install
#cd $HOME
echo "${INSTALL_NAME}.tar.xz"
echo "tar -cJf $HOME/${INSTALL_NAME}.tar.xz -C ${INSTALL_PATH}/../ ${INSTALL_NAME}"
tar -cJf $HOME/${INSTALL_NAME}.tar.xz -C ${INSTALL_PATH}/../ ${INSTALL_NAME}
