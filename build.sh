#!/usr/bin/env sh

XZ_VERSION=5.2.4

rm -rf xz-${XZ_VERSION}*
wget https://tukaani.org/xz/xz-${XZ_VERSION}.tar.bz2
tar xjf xz-${XZ_VERSION}.tar.bz2
cd xz-${XZ_VERSION}

echo "Configure"

# Configure and compile LLVM bitcode
emconfigure ./configure \
  CFLAGS='-static' \
  --disable-assembler \
  --disable-dependency-tracking \
  --disable-doc \
  --disable-scripts \
  || exit $?

echo "Build"
emmake make -j8 || exit $?

# Generate `.wasm` file
echo "Link"

mv src/lzmainfo/lzmainfo src/lzmainfo/lzmainfo.bc
emcc src/lzmainfo/lzmainfo.bc -o ../lzmainfo.wasm

mv src/xz/xz src/xz/xz.bc
emcc src/xz/xz.bc -o ../xz.wasm

mv src/xzdec/xzdec src/xzdec/xzdec.bc
emcc src/xzdec/xzdec.bc -o ../xzdec.wasm

mv src/xzdec/lzmadec src/xzdec/lzmadec.bc
emcc src/xzdec/lzmadec.bc -o ../lzmadec.wasm

echo "Clean"
cd ..
rm -rf xz-${XZ_VERSION}*

# Set executable bit on WebAssembly python binary
chmod +x lzmainfo.wasm
chmod +x xz.wasm
chmod +x xzdec.wasm
chmod +x lzmadec.wasm

echo "Done"
