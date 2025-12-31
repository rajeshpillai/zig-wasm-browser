const std = @import("std");

const width = 200;
const height = 200;
var video_buffer: [width * height]u32 = undefined;

export fn get_video_buffer_ptr() [*]u32 {
    return &video_buffer;
}

// Ensure the pixel is within bounds before drawing
fn put_pixel(x: usize, y: usize, color: u32) void {
    if (x >= width or y >= height) return;
    const index = y * width + x;
    video_buffer[index] = color;
}

// Draw a filled rectangle
fn draw_rect(x: usize, y: usize, w: usize, h: usize, color: u32) void {
    var cy: usize = y;
    while (cy < y + h) : (cy += 1) {
        var cx: usize = x;
        while (cx < x + w) : (cx += 1) {
            put_pixel(cx, cy, color);
        }
    }
}

// Draw a filled circle (naive implementation)
fn draw_circle(cx: isize, cy: isize, radius: isize, color: u32) void {
    var y: isize = cy - radius;
    while (y <= cy + radius) : (y += 1) {
        var x: isize = cx - radius;
        while (x <= cx + radius) : (x += 1) {
            const dx = x - cx;
            const dy = y - cy;
            // Check Euclidean distance squared: x^2 + y^2 <= r^2
            if (dx * dx + dy * dy <= radius * radius) {
                // Cast to usize for pixel plotting (clipping handled by put_pixel implicitly if we check bounds there,
                // but since put_pixel takes usize, we must ensure non-negative here or check bounds carefully)
                if (x >= 0 and y >= 0) {
                     put_pixel(@intCast(x), @intCast(y), color);
                }
            }
        }
    }
}

export fn render() void {
    // Clear screen to dark gray
    // 0xFF333333
    for (&video_buffer) |*pixel| {
        pixel.* = 0xFF333333;
    }

    // Draw a big Blue Rectangle
    // 0xFFFF0000 (Blue, ABGR-ish / Little Endian RGBA -> A=FF, B=FF, G=00, R=00 ? No wait)
    // 0xAABBGGRR
    // Blue = 0xFFFF0000 ??
    // Let's stick to: A=FF, B=00, G=00, R=FF -> Red = 0xFF0000FF
    //                 A=FF, B=FF, G=00, R=00 -> Blue = 0xFFFF0000
    
    // Draw colors
    const red = 0xFF0000FF;
    const green = 0xFF00FF00;
    const blue = 0xFFFF0000;
    const yellow = 0xFF00FFFF;

    draw_rect(20, 20, 50, 50, red);
    draw_rect(80, 20, 50, 50, green);
    
    // Draw Circle
    draw_circle(100, 120, 40, blue);
    
    // Draw tiny centered circle
    draw_circle(100, 120, 5, yellow);
}
