# Tutorial 12: Image Processing Filters

## Goal
Build an Image Processing engine that can read an uploaded image, process it pixel-by-pixel, and display the result.

## Architecture
This tutorial demonstrates **Double Buffering**.
1.  `source_buffer`: Contains the clean, original image sent from JavaScript.
2.  `output_buffer`: Where we write the modified pixels.

Every time we apply a filter (like Blur), we read from `source` and write to `output`. This ensures that applying "Blur" repeatedly doesn't destroy the original image unless we explicitly want to.

## Concepts Implemented

### 1. Color Manipulations
Iterating over every pixel and modifying R, G, B channels individually.
Example: **Grayscale**
```zig
avg = (r + g + b) / 3;
out = (avg, avg, avg);
```

### 2. Convolution Kernels (Blur/Sharpen)
We look at a pixel's neighbors (3x3 grid).
We multiply each neighbor by a weight (the "Kernel") and sum them up.
*   **Blur**: Averages neighbors (all weights 1).
*   **Edge**: Positive center, negative neighbors. This highlights changes in intensity.

### 3. Coordinate Mapping (Distortion)
We look up pixels from different coordinates.
Example: **Pixelate**
For every 10x10 block, we only read the color of the top-left pixel (0,0) and fill the whole block with it.

## The Result
We have a fully functional web app where you can upload photos and apply effects instantly using WebAssembly's raw performance.

## Try it
Run `./build.sh` and open `12-image-filters.html`.
Upload a photo and play with the sliders!
