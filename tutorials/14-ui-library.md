# Tutorial 14: Immediate Mode GUI (UI Library)

## Goal
Build a custom UI library (Buttons, Text, Interaction) running entirely inside WebAssembly on a Pixel Buffer. 
This approach is used by game engines and high-performance apps (Figma, Rive) to avoid the DOM.

## Immediate Mode GUI (IMGUI)
In a traditional "Retained Mode" GUI (like HTML DOM), you create a `<button>` object, and the browser remembers it exists.
In **Immediate Mode**, you simply call `button(...)` inside your render loop every frame.
1.  **Logic**: "If button is clicked, do X".
2.  **Render**: "Draw button at X,Y".

All of this happens 60 times a second.

## The "Button" Function
```zig
fn button(id: u32, text: []const u8, x: i32, y: i32, ...) bool {
    // 1. Hit Test: Is mouse inside?
    if (mouse_inside) hot_item = id;

    // 2. Interaction: Is mouse clicked while hot?
    if (mouse_down and hot_item == id) active_item = id;

    // 3. Render: Draw rect color based on state
    if (active) draw_pressed();
    else if (hot) draw_hover();
    else draw_idle();

    // 4. Return true if clicked
    return (mouse_up and hot == id and active == id);
}
```

## Bitmap Fonts
Since Wasm has no access to `Arial.ttf`, we use a simple **Bitmap Font**. Use `src/font_bitmap.zig` to see how we store the letter 'A' as a 64-bit integer (8x8 pixels) and unpack it bit-by-bit to draw it.

## Try it
Run `./build.sh` and open `14-ui-library.html`.
-   Hover over buttons to see them light up (State: Hot).
-   Click buttons to see them press down (State: Active) and increment the counter.
