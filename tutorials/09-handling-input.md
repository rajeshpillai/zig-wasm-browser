# Tutorial 09: Handling User Input

## Goal
Make the Wasm application interactive by reacting to Mouse and Keyboard events.

## Concepts
WebAssembly cannot "listen" to events directly from the browser DOM. We must:
1.  Listen for events in **JavaScript**.
2.  Call **Exported functions** in Zig to notify it of the event.
3.  Zig updates its internal state variables.
4.  The Render Loop draws the next frame based on the new state.

### 1. Zig Side
We export functions to accept the data.

```zig
export fn set_mouse(x: i32, y: i32) void {
    mouse_x = x;
    mouse_y = y;
}

export fn handle_key(key_code: i32) void {
    if (key_code == 32) { /* Spacebar */ }
}
```

### 2. JavaScript Side
We attach listeners to the canvas (for mouse) or window/document/canvas (for keys).

```javascript
canvas.addEventListener('mousemove', (e) => {
    // Just handling coordinates scaling logic...
    exports.set_mouse(x, y);
});

canvas.addEventListener('keydown', (e) => {
    exports.handle_key(e.keyCode);
});
```

### A Note on Coordinates
Mouse events give you coordinates in "CSS Pixels" on the screen.
Our internal buffer is 200x200.
If the canvas is displayed at 400x400 via CSS, we must scale the input coordinates down by 0.5 to match our internal resolution.

## Try it
Run `./build.sh` and open `09-handling-input.html`.
*   The circle follows your mouse.
*   Press **Space** to turn it Blue.
*   Press **Enter** to turn it Green.
