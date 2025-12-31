# Tutorial 08: The Animation Loop

## Goal
Make things move!

## Concepts

### 1. Persistence
In C/Zig/compiled languages, **Global Variables** live in the program's data segment (linear memory). They don't disappear when a function returns.
If we update a global variable `pos_x += 1` inside an exported function, and call that function 100 times, `pos_x` will increase by 100.
This allows us to maintain the "Game State" entirely inside Wasm.

```zig
var pos_x: isize = 0; // Lives forever

export fn render() void {
    pos_x += 1; // Updates the persistent value
    // ... draw circle at pos_x ...
}
```

### 2. The Loop (`requestAnimationFrame`)
We don't write a `while(true)` loop in Wasm. That would freeze the browser!
Instead, the browser drives the loop.
1.  Browser says: "I'm ready to paint a frame" -> calls JS callback.
2.  JS calls `wasm.render()`.
3.  JS blits the buffer to the canvas.
4.  JS asks for the next frame: `requestAnimationFrame(step)`.

## 3. Clearing the Screen
If we draw a circle at position X, and then next frame draw it at X+1, the old circle at X remains unless we erase it.
Usually, we clear the entire screen (fill with black) at the start of every frame.

```zig
fn clear_screen() void {
    for (&video_buffer) |*pixel| {
        pixel.* = 0xFF000000;
    }
}
```

## Try it
Run `./build.sh` and open `08-animation-loop.html`.
You should see a ball bouncing around smoothly!
