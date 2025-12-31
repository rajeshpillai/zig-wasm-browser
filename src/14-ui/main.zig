const std = @import("std");
const font = @import("font.zig");

const width = 400;
const height = 400;
var video_buffer: [width * height]u32 = undefined;

export fn get_video_buffer_ptr() [*]u32 {
    return &video_buffer;
}

fn put_pixel(x: i32, y: i32, color: u32) void {
    if (x < 0 or x >= width or y < 0 or y >= height) return;
    video_buffer[@intCast(@as(usize, @intCast(y)) * width + @as(usize, @intCast(x)))] = color;
}

fn fill_rect(x: i32, y: i32, w: i32, h: i32, color: u32) void {
    var cy = y;
    while (cy < y + h) : (cy += 1) {
        var cx = x;
        while (cx < x + w) : (cx += 1) {
            put_pixel(cx, cy, color);
        }
    }
}

fn draw_char(c: u8, x: i32, y: i32, color: u32) void {
    const bitmap = font.get_char_bitmap(c);
    var row: usize = 0;
    while (row < 8) : (row += 1) {
        var col: usize = 0;
        while (col < 8) : (col += 1) {
            // Check bit: (bitmap >> (63 - (row*8 + col))) & 1
            const bit_idx = (7 - row) * 8 + (7 - col);
            if ((bitmap >> @intCast(bit_idx)) & 1 == 1) {
                put_pixel(x + @as(i32, @intCast(col)), y + @as(i32, @intCast(row)), color);
            }
        }
    }
}

fn draw_text(text: []const u8, x: i32, y: i32, color: u32) void {
    var cx = x;
    for (text) |char| {
        draw_char(char, cx, y, color);
        cx += 8; // 8px width monospace
    }
}

// --- IMGUI System ---

const UIContext = struct {
    mouse_x: i32,
    mouse_y: i32,
    mouse_down: bool,
    hot_item: u32,    // ID of item under mouse
    active_item: u32, // ID of item being clicked
};

var ui = UIContext{
    .mouse_x = 0,
    .mouse_y = 0,
    .mouse_down = false,
    .hot_item = 0,
    .active_item = 0,
};

// Input Handling
export fn set_mouse(x: i32, y: i32, is_down: bool) void {
    ui.mouse_x = x;
    ui.mouse_y = y;
    ui.mouse_down = is_down;
}

export fn frame_start() void {
    // Reset hot item every frame (re-calculated by widgets)
    ui.hot_item = 0;
    // Clear screen
    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        video_buffer[i] = 0xFF222222; // Dark Gray background
    }
}

// The Button Widget
fn button(id: u32, text: []const u8, x: i32, y: i32, w: i32, h: i32) bool {
    // 1. Hit Test
    if (ui.mouse_x >= x and ui.mouse_x < x + w and
        ui.mouse_y >= y and ui.mouse_y < y + h) 
    {
        ui.hot_item = id;
        if (ui.active_item == 0 and ui.mouse_down) {
            ui.active_item = id;
        }
    }

    // 2. Interaction Logic
    var result = false;
    if (ui.mouse_down == false and ui.hot_item == id and ui.active_item == id) {
        result = true; // Clicked!
        ui.active_item = 0;
    }
    
    // Clear active if mouse released anywhere -> MOVED TO FRAME END
    // if (!ui.mouse_down) {
    //    ui.active_item = 0;
    // }

    // 3. Render
    var bg_color: u32 = 0xFF444444; // Idle: Gray
    if (ui.hot_item == id) {
        bg_color = 0xFF555555; // Hover: Lighter Gray
    }
    if (ui.active_item == id) {
        bg_color = 0xFF888888; // Active: Bright Gray (Pressed)
    }
    
    // Shadow/Height effect
    if (ui.active_item == id) {
        // Pressed down (shift content 1px down-right)
         fill_rect(x + 1, y + 1, w, h, bg_color);
         draw_text(text, x + 12, y + 12, 0xFFFFFFFF); // Centered-ish text
    } else {
        // Raised
         fill_rect(x, y + h, w, 2, 0xFF111111); // Shadow
         fill_rect(x + w, y, 2, h + 2, 0xFF111111); // Shadow
         fill_rect(x, y, w, h, bg_color);
         draw_text(text, x + 10, y + 10, 0xFFFFFFFF);
    }
    
    return result;
}

// The Checkbox Widget
// The Checkbox Widget
fn checkbox(id: u32, text: []const u8, checked: *bool, x: i32, y: i32) bool {
    const box_size = 12;
    // 1. Hit Test (Box + Text area approximation)
    const w = box_size + 10 + @as(i32, @intCast(text.len * 8));
    const h = box_size;
    
    // Check if mouse is strictly inside
    if (ui.mouse_x >= x and ui.mouse_x < x + w and
        ui.mouse_y >= y and ui.mouse_y < y + h) 
    {
        ui.hot_item = id;
        if (ui.active_item == 0 and ui.mouse_down) {
            ui.active_item = id;
        }
    }

    // 2. Interaction
    var result = false;
    // Toggle ONLY on specific condition: Hot, Active, and Mouse JUST Release (was down, now up?)
    // Actually our IMGUI logic is: 
    // - On mouse down: set active_item.
    // - On mouse up: if hot_item == active_item, then CLICKED.
    // But our loop clears active_item if !mouse_down at start of frame? No.
    // Let's rely on the standard "Click" logic:
    // If we are hot, we are potentially clickable.
    // If we were active (pressed down) and now mouse is up (and still hot), trigger.
    
    // Note: The previous logic relied on `if (!ui.mouse_down) ui.active_item = 0;` happening AFTER.
    // But `main.zig` logic says `if (ui.mouse_down == false ...)` which means we handle "Mouse UP" event here.
    
    if (ui.hot_item == id and ui.active_item == id and ui.mouse_down == false) {
        checked.* = !checked.*; // Toggle
        result = true;
    }

    // 3. Render
    var box_color: u32 = 0xFF444444;
    // Visual feedback for interaction
    if (ui.hot_item == id) box_color = 0xFF666666;
    if (ui.active_item == id) box_color = 0xFF888888;
    
    // Draw Box Background
    fill_rect(x, y, box_size, box_size, box_color);
    
    // Draw Border (makes it clearer)
    // Top/Left
    fill_rect(x, y, box_size, 1, 0xFFAAAAAA);
    fill_rect(x, y, 1, box_size, 0xFFAAAAAA);
    // Bottom/Right
    fill_rect(x, y + box_size - 1, box_size, 1, 0xFF222222);
    fill_rect(x + box_size - 1, y, 1, box_size, 0xFF222222);

    if (checked.*) {
        // Draw X (green)
        const check_color = 0xFF00FF00;
        var i: i32 = 2;
        while (i < box_size - 2) : (i += 1) {
            put_pixel(x + i, y + i, check_color);
            put_pixel(x + box_size - 1 - i, y + i, check_color);
        }
    }
    
    // Draw Label
    draw_text(text, x + box_size + 8, y + 2, 0xFFFFFFFF);

    return result;
}

var counter: i32 = 0;
var show_quit: bool = true;

export fn render_ui() void {
    frame_start();

    draw_text("ZIG UI LIBRARY", 10, 10, 0xFF00FFFF);

    if (button(1, "CLICK ME", 50, 50, 100, 30)) {
        counter += 1;
    }

    if (button(2, "RESET", 50, 100, 100, 30)) {
        counter = 0;
    }
    
    // Draw Counter
    var buf: [32]u8 = undefined;
    const slice = std.fmt.bufPrint(&buf, "CLICKS: {d}", .{counter}) catch "ERR";
    draw_text(slice, 200, 60, 0xFF00FF00);
    
    
    // Checkbox Demo
    _ = checkbox(4, "Show Quit Button", &show_quit, 50, 150);

    if (show_quit) {
        if (button(3, "QUIT", 300, 350, 80, 30)) {
            draw_text("BYE!", 320, 320, 0xFF0000FF);
        }
    }

    // Global Input Cleanup
    // If mouse is up, we must eventually drop active_item 
    // (if it wasn't consumed by a click action above)
    if (!ui.mouse_down) {
        ui.active_item = 0;
    }
}
