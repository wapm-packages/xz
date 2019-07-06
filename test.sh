#!/usr/bin/env sh

# ../wasmer/target/release/wasmer run lzmadec.wasm
# ../wasmer/target/release/wasmer run lzmainfo.wasm
# ../wasmer/target/release/wasmer run -- xz.wasm -cd fixture.xz
../wasmer/target/release/wasmer run -- xzdec.wasm -c fixture.xz
