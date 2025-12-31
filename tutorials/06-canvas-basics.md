# Tutorial 06: Canvas Setup & Pixel Buffer

## Goal
Understand how to draw to the screen conceptually. We do not use "drawRect" or "drawCircle" commands. **We control every single pixel directly.**

## 1. What is a "Canvas"?
Conceptually, our canvas is a grid of 200x200 squares (pixels).
In memory, this is just a long list of numbers.

If we have a 3x2 grid:
```
[ (0,0), (1,0), (2,0) ]
[ (0,1), (1,1), (2,1) ]
```
In a 1D array, this looks like:
`[ (0,0), (1,0), (2,0), (0,1), (1,1), (2,1) ]`

To find the index of pixel `(x, y)`:
`index = (y * WIDTH) + x`

## 2. What is a "Pixel"?
One pixel is 4 bytes of information:
1.  **R**: Red (0-255)
2.  **G**: Green (0-255)
3.  **B**: Blue (0-255)
4.  **A**: Alpha/Transparency (0-255)

Usually, this is stored as a 32-bit integer (`u32`).

### The Color Format (Little Endian)
Most processors (x86, ARM, Wasm) are **Little Endian**. This means the *least significant byte* comes first in memory.

If we want `RGBA = (Red, Green, Blue, Alpha)` in memory order:
-   Byte 0: Red
-   Byte 1: Green
-   Byte 2: Blue
-   Byte 3: Alpha

When we write this as a hexadecimal number `0xAABBGGRR`:
-   `RR` (Red) is the lowest byte (last two hex digits) -> **First** in memory.
-   `GG` (Green) -> **Second**.
-   `BB` (Blue) -> **Third**.
-   `AA` (Alpha) -> **Fourth**.

So, for **Red** (255, 0, 0, 255):
-   R=FF, G=00, B=00, A=FF.
-   Hex: `0xFF0000FF`

## 3. The Implementation

### Zig Side
1.  Allocate a buffer `[WIDTH * HEIGHT]u32`.
2.  Export a pointer to it.
3.  Manipulate the `u32` values to change colors.

```zig
// Set pixel at (10, 10) to Red
const index = 10 * width + 10;
video_buffer[index] = 0xFF0000FF; 
```

### JS Side
We use `ImageData`. It expects a `Uint8ClampedArray` (a list of bytes 0-255).
We point this array directly at our Wasm memory!

```javascript
const bufferPtr = exports.get_video_buffer_ptr();
const clampedArray = new Uint8ClampedArray(exports.memory.buffer, bufferPtr, width * height * 4);
const imgData = new ImageData(clampedArray, width, height);
ctx.putImageData(imgData, 0, 0);
```

## Try it
Run `./build.sh` and open `06-canvas-basics.html`.
You will see a white background with 3 distinct colored dots and a black line. This proves we have total control over the video memory!
