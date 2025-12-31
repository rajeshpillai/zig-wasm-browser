const std = @import("std");

const width = 400;
const height = 400;

// Double buffering: Source (Original) -> Output (Filtered)
var source_buffer: [width * height]u32 = undefined;
var output_buffer: [width * height]u32 = undefined;

// PRNG for Noise
var prng = std.Random.DefaultPrng.init(0);
const random = prng.random();

export fn get_output_buffer_ptr() [*]u32 {
    return &output_buffer;
}

export fn get_source_buffer_ptr() [*]u32 {
    return &source_buffer;
}

// Ensure 0-255 range
fn clamp(val: i32) u8 {
    if (val < 0) return 0;
    if (val > 255) return 255;
    return @intCast(val);
}

// Helpers to unpack/pack colors (ABGR / Little Endian RGBA)
// Zig Wasm u32 -> JS Uint32Array usually maps to AABBGGRR (Little Endian)
// So 0xAABBGGRR means:
// Byte 0 (lowest addr): RR
// Byte 1: GG
// Byte 2: BB
// Byte 3: AA
fn get_r(c: u32) u8 { return @truncate(c); }
fn get_g(c: u32) u8 { return @truncate(c >> 8); }
fn get_b(c: u32) u8 { return @truncate(c >> 16); }
fn get_a(c: u32) u8 { return @truncate(c >> 24); }

fn make_color(r: u8, g: u8, b: u8, a: u8) u32 {
    return @as(u32, r) | (@as(u32, g) << 8) | (@as(u32, b) << 16) | (@as(u32, a) << 24);
}

// --- Filters ---

// 1. Grayscale
fn filter_grayscale() void {
    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        const c = source_buffer[i];
        const r = get_r(c);
        const g = get_g(c);
        const b = get_b(c);
        // Luminance formula
        const avg = @divFloor(@as(u32, r) * 77 + @as(u32, g) * 150 + @as(u32, b) * 28, 256);
        const gray: u8 = @intCast(avg);
        output_buffer[i] = make_color(gray, gray, gray, 255);
    }
}

// 2. Brightness (value: -100 to 100)
fn filter_brightness(value: i32) void {
    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        const c = source_buffer[i];
        const r = clamp(@as(i32, get_r(c)) + value);
        const g = clamp(@as(i32, get_g(c)) + value);
        const b = clamp(@as(i32, get_b(c)) + value);
        output_buffer[i] = make_color(r, g, b, 255);
    }
}

// 3. Invert
fn filter_invert() void {
    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        const c = source_buffer[i];
        output_buffer[i] = make_color(255 - get_r(c), 255 - get_g(c), 255 - get_b(c), 255);
    }
}

// 4. Threshold (value: 0-255)
fn filter_threshold(value: i32) void {
    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        const c = source_buffer[i];
        // Simple average
        const avg = (@as(u32, get_r(c)) + get_g(c) + get_b(c)) / 3;
        const out: u8 = if (avg >= value) 255 else 0;
        output_buffer[i] = make_color(out, out, out, 255);
    }
}

// 5. Sepia
fn filter_sepia() void {
    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        const c = source_buffer[i];
        const r = @as(f32, @floatFromInt(get_r(c)));
        const g = @as(f32, @floatFromInt(get_g(c)));
        const b = @as(f32, @floatFromInt(get_b(c)));

        const tr = clamp(@intFromFloat(0.393 * r + 0.769 * g + 0.189 * b));
        const tg = clamp(@intFromFloat(0.349 * r + 0.686 * g + 0.168 * b));
        const tb = clamp(@intFromFloat(0.272 * r + 0.534 * g + 0.131 * b));

        output_buffer[i] = make_color(tr, tg, tb, 255);
    }
}

// 6. Noise (Random) - value: intensity 0-100
fn filter_noise(value: i32) void {
    var i: usize = 0;
    while (i < width * height) : (i += 1) {
        const c = source_buffer[i];
        const r = @as(i32, get_r(c));
        const g = @as(i32, get_g(c));
        const b = @as(i32, get_b(c));

        const noise = (random.intRangeAtMost(i32, -value, value));
        
        output_buffer[i] = make_color(clamp(r + noise), clamp(g + noise), clamp(b + noise), 255);
    }
}

// --- Convolution Helper ---
fn get_pixel_safe(x: isize, y: isize) u32 {
    const ux = clamp_coord(x, width);
    const uy = clamp_coord(y, height);
    return source_buffer[@as(usize, uy) * width + @as(usize, ux)];
}

fn clamp_coord(val: isize, max: usize) usize {
    if (val < 0) return 0;
    if (val >= max) return max - 1;
    return @intCast(val);
}

fn apply_kernel(kernel: [9]i32, divisor: i32) void {
    var y: isize = 0;
    while (y < height) : (y += 1) {
        var x: isize = 0;
        while (x < width) : (x += 1) {
            var r_acc: i32 = 0;
            var g_acc: i32 = 0;
            var b_acc: i32 = 0;

            var ky: isize = -1;
            while (ky <= 1) : (ky += 1) {
                var kx: isize = -1;
                while (kx <= 1) : (kx += 1) {
                    const pixel = get_pixel_safe(x + kx, y + ky);
                    const k_val = kernel[@as(usize, @intCast((ky + 1) * 3 + (kx + 1)))];
                    
                    r_acc += @as(i32, get_r(pixel)) * k_val;
                    g_acc += @as(i32, get_g(pixel)) * k_val;
                    b_acc += @as(i32, get_b(pixel)) * k_val;
                }
            }
            
            output_buffer[@as(usize, @intCast(y)) * width + @as(usize, @intCast(x))] = make_color(
                clamp(@divFloor(r_acc, divisor)),
                clamp(@divFloor(g_acc, divisor)),
                clamp(@divFloor(b_acc, divisor)),
                255
            );
        }
    }
}

// 7. Blur
fn filter_blur() void {
    // 1 1 1
    // 1 1 1
    // 1 1 1  Box Blur
    const kernel = [9]i32{ 1, 1, 1, 1, 1, 1, 1, 1, 1 };
    apply_kernel(kernel, 9);
}

// 8. Sharpen
fn filter_sharpen() void {
    //  0 -1  0
    // -1  5 -1
    //  0 -1  0
    const kernel = [9]i32{ 0, -1, 0, -1, 5, -1, 0, -1, 0 };
    apply_kernel(kernel, 1);
}

// 9. Edge Detect
fn filter_edge() void {
    // -1 -1 -1
    // -1  8 -1
    // -1 -1 -1
    const kernel = [9]i32{ -1, -1, -1, -1, 8, -1, -1, -1, -1 };
    apply_kernel(kernel, 1);
}

// 10. Pixelate (value = block size)
fn filter_pixelate(size: i32) void {
    const block = if (size < 1) 1 else size;
    var y: isize = 0;
    while (y < height) : (y += block) {
        var x: isize = 0;
        while (x < width) : (x += block) {
            // Get color of top-left pixel
            const color = get_pixel_safe(x, y);
            
            // Fill block
            var by: isize = 0;
            while (by < block) : (by += 1) {
                var bx: isize = 0;
                while (bx < block) : (bx += 1) {
                    const py = y + by;
                    const px = x + bx;
                    if (px < width and py < height) {
                         output_buffer[@as(usize, @intCast(py)) * width + @as(usize, @intCast(px))] = color;
                    }
                }
            }
        }
    }
}


export fn apply_filter(filter_id: i32, value: i32) void {
    // Always start from fresh source? 
    // Yes, for this demo we filter Source -> Output. 
    // If output should accumulate, we'd need to copy output to source first. But simple is better.
    
    switch (filter_id) {
        0 => { // Copy Source
             @memcpy(&output_buffer, &source_buffer);
        },
        1 => filter_grayscale(),
        2 => filter_brightness(value), // val: -100 to 100
        3 => filter_invert(),
        4 => filter_threshold(value),  // val: 0-255
        5 => filter_sepia(),
        6 => filter_blur(),
        7 => filter_sharpen(),
        8 => filter_edge(),
        9 => filter_noise(value),      // val: 0-100
        10 => filter_pixelate(value),  // val: 1-50
        else => {} 
    }
}
