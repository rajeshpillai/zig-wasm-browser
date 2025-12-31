const std = @import("std");

const width = 200;
const height = 200;
var video_buffer: [width * height]u32 = undefined;

// Persistent State (Global Variables)
// These keep their values between function calls!
var pos_x: isize = 100;
var pos_y: isize = 100;
var vel_x: isize = 2;
var vel_y: isize = 3;
const radius: isize = 10;

export fn get_video_buffer_ptr() [*]u32 {
    return &video_buffer;
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

// Clear screen to black
fn clear_screen() void {
    for (&video_buffer) |*pixel| {
        pixel.* = 0xFF000000;
    }
}

export fn render() void {
    clear_screen();

    // 1. Update State
    pos_x += vel_x;
    pos_y += vel_y;

    // 2. Collision Detection (Bounce)
    if (pos_x - radius < 0 or pos_x + radius >= width) {
        vel_x *= -1;
    }
    if (pos_y - radius < 0 or pos_y + radius >= height) {
        vel_y *= -1;
    }

    // 3. Draw
    // Draw bouncing ball (Red)
    draw_circle(pos_x, pos_y, radius, 0xFF0000FF);
}
