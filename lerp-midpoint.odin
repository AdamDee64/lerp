package lerpmidpoint

import rl "vendor:raylib"

Vec2 :: rl.Vector2
Rect :: rl.Rectangle
Color :: rl.Color

DARKESTGRAY :: Color{50, 50, 50, 255}

Midpoint :: struct{
    points : [16]Vec2,
    path : Vec2
}

main :: proc() {
    
    WIDTH   :: 800
    HEIGHT  :: 600
    FPS     :: 60
    TITLE : cstring : "Lerp - points between points"

    origin : Vec2 = {WIDTH/2, HEIGHT/2}

    end_point_one : Vec2 = {100, HEIGHT / 2}
    end_point_two : Vec2 = {WIDTH - 100, HEIGHT / 2}

    midpoints : Midpoint
    
    midpoints.path = end_point_two - end_point_one
    for i in 0..<len(midpoints.points) {
        interval := 1 / f32(len(midpoints.points) + 1)
        midpoints.points[i] = end_point_one + (interval + interval * f32(i)) * midpoints.path
    }

    grabbed := 0

    draw_text_one : cstring = "click on either gold ball to move them"
    
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(FPS)
    
    for !rl.WindowShouldClose() {

        if rl.IsMouseButtonPressed(rl.MouseButton(0)){
            if rl.CheckCollisionPointCircle(rl.GetMousePosition(), end_point_one, 20){
                if grabbed == 0{
                    grabbed = 1
                } else {
                    grabbed = 0
                }
            }
            if rl.CheckCollisionPointCircle(rl.GetMousePosition(), end_point_two, 20){
                if grabbed == 0{
                    grabbed = 2
                } else {
                    grabbed = 0
                }
            }
        }

        if grabbed > 0{
            if grabbed == 1{
                end_point_one = rl.GetMousePosition()
            } else if grabbed == 2 {
                end_point_two = rl.GetMousePosition()
            }
            midpoints.path = end_point_two - end_point_one
            for i in 0..<len(midpoints.points) {
                interval := 1 / f32(len(midpoints.points) + 1)
                midpoints.points[i] = end_point_one + (interval + interval * f32(i)) * midpoints.path
            }
        }

        rl.BeginDrawing()
        
        rl.ClearBackground(rl.BLACK)

        for i in 0..<len(midpoints.points) {
            rl.DrawCircleV(midpoints.points[i], 10, rl.BLUE)
        }

        rl.DrawCircleV(end_point_one, 20, rl.GOLD)
        rl.DrawCircleV(end_point_two, 20, rl.GOLD)

        rl.DrawText(draw_text_one, 20, HEIGHT - 35, 20, DARKESTGRAY)
            
        rl.EndDrawing()
    }

    rl.CloseWindow()
}