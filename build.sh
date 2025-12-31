#!/bin/bash
set -e

# Tutorial 01
echo "Building Tutorial 01: Hello World..."
zig build-exe src/01-hello-world.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=add -rdynamic --name 01-hello-world
mv 01-hello-world.wasm public/
rm 01-hello-world.wasm.o || true

# Tutorial 02
echo "Building Tutorial 02: JS Imports..."
zig build-exe src/02-js-imports.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=add -rdynamic --name 02-js-imports
mv 02-js-imports.wasm public/
rm 02-js-imports.wasm.o || true

# Tutorial 03
echo "Building Tutorial 03: Wasm Memory..."
zig build-exe src/03-wasm-memory.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=get_counter_ptr --export=increment -rdynamic --name 03-wasm-memory
mv 03-wasm-memory.wasm public/
rm 03-wasm-memory.wasm.o || true

echo "Done!"
