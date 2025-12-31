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

# Tutorial 04
echo "Building Tutorial 04: Strings..."
zig build-exe src/04-passing-strings.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=get_greeting_ptr --export=get_greeting_len --export=get_input_buffer_ptr --export=print_input_buffer -rdynamic --name 04-passing-strings
mv 04-passing-strings.wasm public/
rm 04-passing-strings.wasm.o || true

# Tutorial 05
echo "Building Tutorial 05: Arrays..."
zig build-exe src/05-arrays-slices.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=get_input_buffer_ptr --export=process_array -rdynamic --name 05-arrays-slices
mv 05-arrays-slices.wasm public/
rm 05-arrays-slices.wasm.o || true

# Tutorial 06
echo "Building Tutorial 06: Canvas Basics..."
zig build-exe src/06-canvas-basics.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=get_video_buffer_ptr --export=render -rdynamic --name 06-canvas-basics
mv 06-canvas-basics.wasm public/
rm 06-canvas-basics.wasm.o || true

# Tutorial 07
echo "Building Tutorial 07: Drawing Shapes..."
zig build-exe src/07-drawing-shapes.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=get_video_buffer_ptr --export=render -rdynamic --name 07-drawing-shapes
mv 07-drawing-shapes.wasm public/
rm 07-drawing-shapes.wasm.o || true

# Tutorial 08
echo "Building Tutorial 08: Animation Loop..."
zig build-exe src/08-animation-loop.zig -target wasm32-freestanding -O ReleaseSmall -fno-entry --export=get_video_buffer_ptr --export=render -rdynamic --name 08-animation-loop
mv 08-animation-loop.wasm public/
rm 08-animation-loop.wasm.o || true

echo "Done!"
