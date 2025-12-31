#!/bin/bash
set -e

# Tutorial 01
echo "Building Tutorial 01: Hello World..."
zig build-exe src/hello.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=add -rdynamic --name hello
mv hello.wasm public/
rm hello.wasm.o || true # cleanup object file if it exists, zig build-exe might leave it or not depending on version

echo "Done!"
