package lerptime

import rl "vendor:raylib"

Vec2 :: rl.Vector2
Rect :: rl.Rectangle
Color :: rl.Color

DARKESTGRAY :: Color{50, 50, 50, 255}

main :: proc() {
    
    WIDTH   :: 800
    HEIGHT  :: 600
    FPS     :: 60
    TITLE : cstring : "Lerp - motion over time"

    origin : Vec2 = {WIDTH/2, HEIGHT/2}

    leader  : Vec2 = {-100, -100} + origin
    follower: Vec2 = {100, -100} + origin
    path    : Vec2 = leader - follower
    progress : f32 = 0
    time    : f32 = 2.0

    leading := false
    moving_leader := false

    draw_text_one : cstring = "click on gold ball to move it."
    draw_text_two : cstring = "press G to toggle lerp on/off"
    
    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    rl.SetTargetFPS(FPS)
    
    for !rl.WindowShouldClose() {

        if rl.IsMouseButtonPressed(rl.MouseButton(0)){
            if rl.CheckCollisionPointCircle(rl.GetMousePosition(), leader, 20){
                moving_leader = !moving_leader
            }
        }

        if rl.IsKeyPressed(rl.KeyboardKey.G) {
            leading = !leading
            if !leading {
                path = leader - follower
                progress = 0
            }
        }

        if moving_leader {
            leader = rl.GetMousePosition()
            path = leader - follower
            progress = 0

        }

        if leading && progress < 1.0{
            step := 1 / time * rl.GetFrameTime()
            progress += step
            follower += step * path
        }

        rl.BeginDrawing()
        
        rl.ClearBackground(rl.BLACK)

        rl.DrawCircleV(follower, 20, rl.RAYWHITE)
        rl.DrawCircleV(leader, 20, rl.GOLD) 

        rl.DrawText(draw_text_one, 20, HEIGHT - 60, 20, DARKESTGRAY)
        rl.DrawText(draw_text_two, 20, HEIGHT - 35, 20, DARKESTGRAY)
            
        rl.EndDrawing()
    }

    rl.CloseWindow()
}