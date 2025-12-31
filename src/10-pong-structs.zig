const std = @import("std");

const width = 200;
const height = 200;
var video_buffer: [width * height]u32 = undefined;

export fn get_video_buffer_ptr() [*]u32 {
    return &video_buffer;
}

fn put_pixel(x: isize, y: isize, color: u32) void {
    if (x < 0 or x >= width or y < 0 or y >= height) return;
    video_buffer[@intCast(@as(usize, @intCast(y)) * width + @as(usize, @intCast(x)))] = color;
}

// --- Structs ---

const Ball = struct {
    x: isize,
    y: isize,
    vel_x: isize,
    vel_y: isize,
    radius: isize,
    color: u32,

    fn update(self: *Ball) void {
        self.x += self.vel_x;
        self.y += self.vel_y;

        // Bounce horizontally
        if (self.x - self.radius < 0 or self.x + self.radius >= width) {
            self.vel_x *= -1;
        }
        // Bounce vertically
        if (self.y - self.radius < 0 or self.y + self.radius >= height) {
            self.vel_y *= -1;
        }
    }

    fn draw(self: Ball) void {
        var y = self.y - self.radius;
        while (y <= self.y + self.radius) : (y += 1) {
            var x = self.x - self.radius;
            while (x <= self.x + self.radius) : (x += 1) {
                const dx = x - self.x;
                const dy = y - self.y;
                if (dx * dx + dy * dy <= self.radius * self.radius) {
                    put_pixel(x, y, self.color);
                }
            }
        }
    }
};

const Paddle = struct {
    x: isize,
    y: isize,
    w: isize,
    h: isize,
    color: u32,
    speed: isize,

    fn moveUp(self: *Paddle) void {
        self.y -= self.speed;
        if (self.y < 0) self.y = 0;
    }

    fn moveDown(self: *Paddle) void {
        self.y += self.speed;
        if (self.y + self.h >= height) self.y = height - self.h;
    }

    fn draw(self: Paddle) void {
        var cy: isize = self.y;
        while (cy < self.y + self.h) : (cy += 1) {
            var cx: isize = self.x;
            while (cx < self.x + self.w) : (cx += 1) {
                put_pixel(cx, cy, self.color);
            }
        }
    }
};

const GameState = struct {
    ball: Ball,
    paddle: Paddle,
};

// Global Game State
var state: GameState = undefined;

// --- Exported Functions ---

export fn init() void {
    state = GameState{
        .ball = Ball{
            .x = 100, .y = 100,
            .vel_x = 2, .vel_y = 2,
            .radius = 5,
            .color = 0xFF0000FF, // Red
        },
        .paddle = Paddle{
            .x = 10, .y = 80,
            .w = 5, .h = 40,
            .speed = 4,
            .color = 0xFF00FF00, // Green
        },
    };
}

// Input: 1 = Up, 2 = Down, 0 = None
export fn set_input(input: i32) void {
    if (input == 1) {
        state.paddle.moveUp();
    } else if (input == 2) {
        state.paddle.moveDown();
    }
}

export fn render() void {
    // Clear
    for (&video_buffer) |*pixel| {
        pixel.* = 0xFF000000;
    }

    // Update
    state.ball.update();

    // Draw
    state.paddle.draw();
    state.ball.draw();
}
