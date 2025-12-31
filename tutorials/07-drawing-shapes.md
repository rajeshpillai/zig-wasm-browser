# Tutorial 07: Drawing Shapes

## Goal
Implement basic 2D drawing functions (`draw_rect`, `draw_circle`) by implementing the algorithms yourself.

## 1. Pixel Plotting helper
First, it's helpful to have a helper function to set a single pixel safely.

```zig
fn put_pixel(x: usize, y: usize, color: u32) void {
    if (x >= width or y >= height) return; // Clipping
    video_buffer[y * width + x] = color;
}
```

## 2. Drawing a Rectangle
A rectangle is just a double loop over x and y.

```zig
fn draw_rect(x: usize, y: usize, w: usize, h: usize, color: u32) void {
    var cy = y;
    while (cy < y + h) : (cy += 1) {
        var cx = x;
        while (cx < x + w) : (cx += 1) {
            put_pixel(cx, cy, color);
        }
    }
}
```

## 3. Drawing a Circle
We check every pixel in a bounding box around the center. If the distance from the center is less than the radius (using Pythagoras: $a^2 + b^2 = c^2$), we color it.

```zig
fn draw_circle(cx: isize, cy: isize, radius: isize, color: u32) void {
    // Iterate from top-left to bottom-right of bounding box
    var y = cy - radius;
    while (y <= cy + radius) : (y += 1) {
        var x = cx - radius;
        while (x <= cx + radius) : (x += 1) {
            
            const dx = x - cx;
            const dy = y - cy;
            if (dx*dx + dy*dy <= radius*radius) {
                // Draw! (Handling unsigned casts carefully)
                if (x >= 0 and y >= 0) {
                     put_pixel(@intCast(x), @intCast(y), color);
                }
            }
        }
    }
}
```

## Why do this ourselves?
Canvas has `ctx.fillRect`, so why write it in Zig?
1.  **Performance**: For thousands of particles or complex procedural generation, Wasm is faster than calling JS functions thousands of times per frame.
2.  **Control**: You own the pixel buffer. You can apply filters, blurs, or raytracing logic that Canvas API doesn't support directly.
3.  **Portability**: This same code could write to a texture in OpenGL or Vulkan later.

## Try it
Run `./build.sh` and open `07-drawing-shapes.html`.
