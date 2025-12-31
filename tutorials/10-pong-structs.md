# Tutorial 10: Project Pong (Part 1 - Structs)

## Goal
Refactor the "Bouncing Ball" into a clean game architecture using Structs.

## Why Structs?
Instead of managing dozens of global variables like:
```zig
var ball_x: i32 = 0;
var ball_y: i32 = 0;
var p1_x: i32 = 0;
```
We group them:
```zig
const Ball = struct { x: i32, y: i32 };
var ball = Ball{ .x=0, .y=0 };
```
This fundamental concept allows us to scale our game complexity without losing our minds.

## Zig Features Used
1.  **Struct Definition**: `const Name = struct { ... };`
2.  **Methods**: Functions declared inside a struct can be called with `object.method()`.
    -   `fn update(self: *Ball) void`: Takes a pointer, so it can modify the struct.
    -   `fn draw(self: Ball) void`: Takes a copy (or const ref), read-only.
3.  **Composition**: `GameState` contains `Ball` and `Paddle`.

## The Result
We now have a bouncing red ball and a green paddle that responds to user input (Up/Down arrows).
Crucially, the logic regarding "How a ball moves" resides INSIDE the `Ball` struct, not floating in a random global function.

## Try it
Run `./build.sh` and open `10-pong-structs.html`.
-   **Up Arrow**: Move Paddle Up
-   **Down Arrow**: Move Paddle Down
