# Tutorial 13: Optimization Demo (The Mandelbrot Set)

## Goal
Visualize the Mandelbrot Set, a famous fractal, to demonstrate the raw processing power of WebAssembly.

## The Math
The set is defined by the formula:
$$ z_{n+1} = z_n^2 + c $$
where $z$ and $c$ are complex numbers.

For each pixel on our screen:
1.  Map the pixel coordinate $(x, y)$ to a complex number $c$.
2.  Start with $z = 0$.
3.  Repeatedly apply the formula.
4.  If the magnitude $|z|$ exceeds 2.0, the point "escapes" to infinity. We stop.
5.  If we reach a maximum number of iterations (e.g., 100) without escaping, we assume the point is inside the set.

## Why Wasm?
This algorithm requires checking every single pixel (400x400 = 160,000 pixels). 
For each pixel, we might run the loop up to 100 times.
That's **16 million iterations per frame**.
JavaScript can do this, but it will heat up your CPU. Zig/Wasm compiles this down to highly optimized machine code that runs incredibly fast, often maintaining smooth 60 FPS even while zooming deeper into the fractal.

## The Code
We treat the `render` function as a camera. It takes `zoom`, `pan_x`, and `pan_y` to determine which part of the mathematical universe to show in our pixel buffer.

## Try it
Run `./build.sh` and open `13-mandelbrot.html`.
*   **Left Click**: Zoom In.
*   **Right Click**: Zoom Out.
Explore the infinite complexity!
