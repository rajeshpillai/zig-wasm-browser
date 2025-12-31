const std = @import("std");

// We define our canvas dimensions here (must match HTML side)
const width = 200;
const height = 200;

// The video buffer representing pixels.
// u32 = 4 bytes (Red, Green, Blue, Alpha).
// Size = width * height pixels.
var video_buffer: [width * height]u32 = undefined;

export fn get_video_buffer_ptr() [*]u32 {
    return &video_buffer;
}

// Render function: Writes colors to the buffer
export fn render() void {
    // 1. Fill background with White
    // 0xFFFFFFFF = Alpha:255, Blue:255, Green:255, Red:255 (Little Endian)
    for (&video_buffer) |*pixel| {
        pixel.* = 0xFFFFFFFF;
    }

    // 2. Draw a Red Pixel at (10, 10).
    // Color: 0xFF0000FF (Alpha:255, Blue:0, Green:0, Red:255)
    // Index: y * width + x
    const idx_red = 10 * width + 10;
    video_buffer[idx_red] = 0xFF0000FF;

    // 3. Draw a Green Pixel at (20, 10).
    // Color: 0xFF00FF00 (Alpha:255, Blue:0, Green:255, Red:0)
    const idx_green = 10 * width + 20;
    video_buffer[idx_green] = 0xFF00FF00;

    // 4. Draw a Blue Pixel at (30, 10).
    // Color: 0xFFFF0000 (Alpha:255, Blue:255, Green:0, Red:0)
    const idx_blue = 10 * width + 30;
    video_buffer[idx_blue] = 0xFFFF0000;
    
    // 5. Draw a black line manually
    var x: usize = 0;
    while (x < width) : (x += 1) {
       const idx = 50 * width + x; // Row 50
       video_buffer[idx] = 0xFF000000; // Alpha:255, B:0, G:0, R:0
    }
}
