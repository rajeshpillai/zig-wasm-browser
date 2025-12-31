const std = @import("std");

const width = 400;
const height = 400;
var video_buffer: [width * height]u32 = undefined;

export fn get_video_buffer_ptr() [*]u32 {
    return &video_buffer;
}

// Map pixel coordinates to Mandelbrot coordinate space
// Default: x [-2.5, 1.0], y [-1.0, 1.0]

fn put_pixel(x: usize, y: usize, r: u8, g: u8, b: u8) void {
    const color = @as(u32, r) | (@as(u32, g) << 8) | (@as(u32, b) << 16) | (255 << 24);
    video_buffer[y * width + x] = color;
}



export fn render(zoom: f64, pan_x: f64, pan_y: f64) void {
    const max_iter = 100;
    
    // Scale factor to keep aspect ratio
    // We want the view to fit in -2.5..1.0 width wise
    
    var y: usize = 0;
    while (y < height) : (y += 1) {
        var x: usize = 0;
        while (x < width) : (x += 1) {
            
            // Screen (0..400) -> World Coords
            // Center is (200, 200)
            const xx = (@as(f64, @floatFromInt(x)) - width / 2.0) / zoom + pan_x;
            const yy = (@as(f64, @floatFromInt(y)) - height / 2.0) / zoom + pan_y;

            // Mandelbrot: z = z^2 + c
            // c = xx + i*yy
            // z starts at 0
            
            var zx: f64 = 0;
            var zy: f64 = 0;
            var iter: u32 = 0;
            
            while (iter < max_iter and (zx*zx + zy*zy) < 4.0) : (iter += 1) {
                const tmp = zx*zx - zy*zy + xx;
                zy = 2.0*zx*zy + yy;
                zx = tmp;
            }
            
            // Color mapping
            var r: u8 = 0;
            var g: u8 = 0;
            var b: u8 = 0;
            
            if (iter == max_iter) {
                // Inside set = Black
                r = 0; g = 0; b = 0;
            } else {
                // Outside = Color based on iter
                const n = @as(f64, @floatFromInt(iter));
                const c = @as(u8, @intFromFloat(255.0 * n / @as(f64, @floatFromInt(max_iter))));
                r = c;
                g = @as(u8, @intFromFloat(n * 5.0)) % 255;
                b = 255 - c;
            }
            
            put_pixel(x, y, r, g, b);
        }
    }
}
