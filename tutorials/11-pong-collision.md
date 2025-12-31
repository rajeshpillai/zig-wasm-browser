# Tutorial 11: Project Pong (Collision)

## Goal
Implement Axis-Aligned Bounding Box (AABB) collision detection to bounce the ball off the paddle.

## AABB Detection
AABB checks if two non-rotated rectangles overlap. The logic is simple: they overlap if **ALL** of these are true:
1.  Rect A's left edge < Rect B's right edge
2.  Rect A's right edge > Rect B's left edge
3.  Rect A's top edge < Rect B's bottom edge
4.  Rect A's bottom edge > Rect B's top edge

If any of these are false, there is a "gap" between them, so no collision.

```zig
fn checkCollision(ball: Ball, paddle: Paddle) bool {
    // Calculate edges...
    return b_left < p_right and b_right > p_left and ...
}
```

## Physics Response
When a collision is detected, we need to respond.
In Pong, it's simple: Bounce!
We invert the X velocity of the ball so it travels in the opposite direction.
```zig
ball.vel_x *= -1;
```
*Crucial Detail*: We also force the velocity to be positive (moving right) because if the ball gets slightly inside the paddle during one frame, simply multiplying by -1 might trap it inside the paddle (sticking glitch).

## Scoring
We also check if the ball hits the Left Wall (`x < 0`).
If so, the player missed. We reset the ball position and increment a counter.

## Try it
Run `./build.sh` and open `11-pong-collision.html`.
Play Pong!
