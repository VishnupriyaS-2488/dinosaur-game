# Code Guide for Beginners

## 1. What is Raylib?
A C library that handles windows, drawing, keyboard and sound so you don't need to write Windows-specific code.
`#include "raylib.h"` gives you functions like `DrawRectangle(...)` and `IsKeyPressed(KEY_SPACE)`.

## 2. Creating the window
```c
InitWindow(960, 360, "Dino Runner");   // open window
...
CloseWindow();                          // close it at the end
```
The game draws on a small 800x300 "virtual screen" (`renderTarget`) that is scaled to the window, so fullscreen just works.

## 3. The game loop
```c
while (!WindowShouldClose() && !quitRequested) {
    float dt = GetFrameTime();   // seconds since last frame (~0.016)
    UpdateGame(dt);              // 1) change numbers (positions, score)
    DrawGame();                  // 2) draw what those numbers say
}
```
Every frame = "update, then draw". `dt` (delta time) makes movement frame-rate independent:
`x -= speed * dt;` moves the same distance per second on a slow or fast computer.

## 4. Keyboard input
`IsKeyPressed(KEY_SPACE)` is true only on the frame the key goes down (good for jumping).
`IsKeyDown(KEY_DOWN)` is true while it is held (good for ducking).

## 5. Jumping and gravity (`UpdateDino`)
```c
dino.velY = -JUMP_VELOCITY;        // negative = up (screen y grows downward)
...each frame in the air:
dino.velY += GRAVITY * dt;         // gravity changes speed
dino.y    += dino.velY * dt;       // speed changes position
if (dino.y >= GROUND_Y) { dino.y = GROUND_Y; dino.onGround = true; }
```
A jump only starts if `dino.onGround` is true, so double-jumping is impossible. Letting go of jump early
caps the upward speed (short hop). Holding DOWN in the air multiplies gravity (fast fall).

## 6. Obstacles (`SpawnObstacle`, `UpdateObstacles`)
Obstacles live in a fixed array `obstacles[8]`; `active` says whether a slot is in use (no malloc, no leaks).
`spawnDistance` counts down by `gameSpeed * dt`; at 0 a new obstacle is created and a new gap is chosen
(`NextSpawnDistance`): minimum = enough room to land and jump again, plus a random extra. Birds only appear
after score 300, at 3 heights: low (jump), middle (duck), high (run under).

## 7. Collision detection (`CheckCollisions`)
Every object has one or two rectangles (hitboxes), slightly smaller than the drawing so it feels fair.
Two rectangles overlap if they overlap on both the x axis and the y axis: `CheckCollisionRecs(a, b)`.
If they overlap, `KillDino()` runs and the state becomes `STATE_GAMEOVER`.

## 8. Scoring
`score += gameSpeed * dt * 0.04f;` (distance based). Speed = `START_SPEED + score * 0.28`, capped at `MAX_SPEED`.
Every 100 points: milestone sound + blinking score. Every 500: +25 bonus. Every 600 points day <-> night
(`nightFactor` glides between 0 and 1 and `Tint(day, night)` blends all colours). The best score is saved
to `dino_save.dat` when you beat it.

## 9. Restart
`ChangeState(STATE_PLAYING)` fades the screen to black; while it is black `ResetGame()` sets score, speed,
dino, obstacles and particles back to start values; then the screen fades back in.

## 10. Compiling and running
`compile.bat` runs GCC: it compiles `src/main.c`, links Raylib (`-lraylib` + Windows graphics libraries)
and writes `build\DinoRunner.exe`. `run.bat` starts it.

## Easy things to change (all near the top of main.c)
`GRAVITY`, `JUMP_VELOCITY` (jump feel) - `START_SPEED`, `MAX_SPEED` (difficulty) - `NIGHT_INTERVAL` (day/night)
- obstacle sizes in `SpawnObstacle` - colours in the `Tint(day, night)` calls.
