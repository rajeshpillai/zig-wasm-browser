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
    score: i32,
};

var state: GameState = undefined;

// --- Helper Logic ---

// Axis-Aligned Bounding Box (AABB) Collision
fn checkCollision(ball: Ball, paddle: Paddle) bool {
    // Ball is a "point" with radius?
    // Let's treat ball as a square for simple AABB, 
    // or checks against center point + radius.
    // Simple AABB for now: Ball bounding box vs Paddle bounding box
    
    // Ball Box
    const b_left = ball.x - ball.radius;
    const b_right = ball.x + ball.radius;
    const b_top = ball.y - ball.radius;
    const b_bottom = ball.y + ball.radius;

    // Paddle Box
    const p_left = paddle.x;
    const p_right = paddle.x + paddle.w;
    const p_top = paddle.y;
    const p_bottom = paddle.y + paddle.h;

    return b_left < p_right and b_right > p_left and
           b_top < p_bottom and b_bottom > p_top;
}

// --- Exported Functions ---

export fn init() void {
    // Seeding random? For now, deterministic start
    reset_ball();
    state.score = 0;
    state.paddle = Paddle{
        .x = 20, .y = 80, // Paddle on the left side
        .w = 5, .h = 40,
        .speed = 4,
        .color = 0xFF00FF00, // Green
    };
}

fn reset_ball() void {
    state.ball = Ball{
        .x = 100, .y = 100,
        .vel_x = 2, .vel_y = 2,
        .radius = 5,
        .color = 0xFF0000FF, // Red
    };
}

export fn get_score() i32 {
    return state.score;
}

export fn set_input(input: i32) void {
    if (input == 1) state.paddle.moveUp();
    if (input == 2) state.paddle.moveDown();
}

export fn update() void {
    // Move Ball
    state.ball.x += state.ball.vel_x;
    state.ball.y += state.ball.vel_y;

    // Bounce off Top/Bottom walls
    if (state.ball.y - state.ball.radius < 0 or state.ball.y + state.ball.radius >= height) {
        state.ball.vel_y *= -1;
    }

    // Bounce off Right wall
    if (state.ball.x + state.ball.radius >= width) {
        state.ball.vel_x *= -1;
    }

    // Check Paddle Collision (Left side)
    if (checkCollision(state.ball, state.paddle)) {
        // Bounce!
        // Simple physics: just invert X velocity
        // Make sure we push it out of the paddle so it doesn't get stuck
        state.ball.vel_x = @intCast(@abs(state.ball.vel_x)); // Force positive X velocity (move right)
    }

    // Check Loss (Left wall)
    if (state.ball.x - state.ball.radius < 0) {
        // Reset
        state.score += 1; // Wait, usually you score if opponent misses. 
        // Since it's 1 player squash-pong, let's just count "Deaths" as score? 
        // No, let's invert: Score = Hits. 
        // Actually, let's keep it simple: Reset ball, maybe negative score?
        // Let's say Score = Number of Resets (Bad Score). 
        // Or let's imply we are playing mostly to stay alive.
        // Let's just reset ball.
        reset_ball();
    }
}

export fn render() void {
    // Update Logic first (can be separated, but doing here for simplicity of JS loop)
    update();

    // Clear
    for (&video_buffer) |*pixel| {
        pixel.* = 0xFF000000;
    }

    state.paddle.draw();
    state.ball.draw();
}
