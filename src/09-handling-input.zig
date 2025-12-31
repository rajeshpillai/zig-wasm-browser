const std = @import("std");

const width = 200;
const height = 200;
var video_buffer: [width * height]u32 = undefined;

// State
var mouse_x: isize = 100;
var mouse_y: isize = 100;

// Color State: Red by default
var current_color: u32 = 0xFF0000FF; // ABGR: Red

export fn get_video_buffer_ptr() [*]u32 {
    return &video_buffer;
}

// Input Handlers
export fn set_mouse(x: i32, y: i32) void {
    mouse_x = x;
    mouse_y = y;
}

export fn handle_key(key_code: i32) void {
    // Simple logic: Change color based on key
    // Using simple toggles or random logic for demo
    // Spacebar (32) -> Blue
    // Enter (13) -> Green
    // Any other -> Red
    if (key_code == 32) {
        current_color = 0xFFFF0000; // Blue
    } else if (key_code == 13) {
        current_color = 0xFF00FF00; // Green
    } else {
        current_color = 0xFF0000FF; // Red
    }
}

fn put_pixel(x: isize, y: isize, color: u32) void {
    if (x < 0 or x >= width or y < 0 or y >= height) return;
    video_buffer[@intCast(@as(usize, @intCast(y)) * width + @as(usize, @intCast(x)))] = color;
}

fn draw_circle(cx: isize, cy: isize, r: isize, color: u32) void {
    var y = cy - r;
    while (y <= cy + r) : (y += 1) {
        var x = cx - r;
        while (x <= cx + r) : (x += 1) {
            const dx = x - cx;
            const dy = y - cy;
            if (dx*dx + dy*dy <= r*r) {
                put_pixel(x, y, color);
            }
        }
    }
}

export fn render() void {
    // Clear screen
    for (&video_buffer) |*pixel| {
        pixel.* = 0xFF000000;
    }

    // Draw circle at mouse position with current color
    draw_circle(mouse_x, mouse_y, 15, current_color);
}
