#!/usr/bin/env sh

XZ_VERSION=5.2.4

rm -rf xz-${XZ_VERSION}*
wget https://tukaani.org/xz/xz-${XZ_VERSION}.tar.bz2
tar xjf xz-${XZ_VERSION}.tar.bz2
cd xz-${XZ_VERSION}

echo "Configure"

# Configure and compile LLVM bitcode
emconfigure ./configure \
  --disable-assembler \
  --disable-doc \
  --disable-scripts \
  || exit $?

echo "Build"
emmake make -j8 || exit $?

# Generate `.wasm` file
echo "Link"

mv src/lzmainfo/.libs/lzmainfo src/lzmainfo/.libs/lzmainfo.bc
emcc src/lzmainfo/.libs/lzmainfo.bc -o ../lzmainfo.wasm -s ERROR_ON_UNDEFINED_SYMBOLS=0

mv src/xz/.libs/xz src/xz/.libs/xz.bc
emcc src/xz/.libs/xz.bc -o ../xz.wasm -s ERROR_ON_UNDEFINED_SYMBOLS=0

mv src/xzdec/.libs/xzdec src/xzdec/.libs/xzdec.bc
emcc src/xzdec/.libs/xzdec.bc -o ../xzdec.wasm -s ERROR_ON_UNDEFINED_SYMBOLS=0

mv src/xzdec/.libs/lzmadec src/xzdec/.libs/lzmadec.bc
emcc src/xzdec/.libs/lzmadec.bc -o ../lzmadec.wasm -s ERROR_ON_UNDEFINED_SYMBOLS=0

echo "Clean"
cd ..
rm -rf xz-${XZ_VERSION}*

# Set executable bit on WebAssembly python binary
chmod +x lzmainfo.wasm
chmod +x xz.wasm
chmod +x xzdec.wasm
chmod +x lzmadec.wasm

echo "Done"
