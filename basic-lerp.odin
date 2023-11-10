package basic

import rl "vendor:raylib"
import "core:fmt"
import rand "core:math/rand"

Vec2 :: rl.Vector2
Rect :: rl.Rectangle
Color :: rl.Color

DARKESTGRAY :: Color{50, 50, 50, 255}

Clamp :: proc(value : f32, min : f32, max : f32) -> f32 {
    if value < min {
        return min
    }
    if value > max {
        return max
    }
    return value
}

main :: proc() {
    
    width   :: 800
    height  :: 600
    fps     :: 60
    title : cstring : "Basic Lerp"

    origin : Vec2 = {width/2, height/2}

    slider      : Rect = {100, 50, 200, 25}
    slider_min  : f32 = slider.x
    slider_max  : f32 = slider.x + slider.width
    slider_tab  : Rect = {200-5, 40, 10, 45}

    button_rand : Rect = {20, height - 60, 170, 50}
    button_rand_text : cstring = "randomize"

    point_A : Vec2 = {-350, 200} + origin
    point_B : Vec2 = {248, -110} + origin

    t : f32 = 0.5
    t_display : cstring = "t: 0.50"

    draw_text_line_one : cstring = "use slider to interpolate blue dot between the gold dots"

    point_I : Vec2 = point_B * t + point_A * (1 - t)
    
    rl.InitWindow(width, height, title)

    rl.SetTargetFPS(fps)
    
    for !rl.WindowShouldClose() {

        if rl.IsMouseButtonDown(rl.MouseButton(0)){
            mouse : Vec2 = rl.GetMousePosition()
            if rl.CheckCollisionPointRec(mouse, slider){\
                slider_tab.x = clamp(mouse.x, slider_min, slider_max)
                t = (slider_tab.x - slider_min) / (slider_max - slider_min)
                point_I = point_B * t + point_A * (1 - t)
                t_display = fmt.ctprintf("t: %.2f", t)
            }
        }
        if rl.IsMouseButtonPressed(rl.MouseButton(0)){
            mouse : Vec2 = rl.GetMousePosition()
            if rl.CheckCollisionPointRec(mouse, button_rand){
                point_A.x = rand.float32_range(-350, -50) + origin.x
                point_A.y = rand.float32_range(-200, 200) + origin.y
                point_B.x = rand.float32_range(50, 350) + origin.x
                point_B.y = rand.float32_range(-200, 200) + origin.y

                point_I = point_B * t + point_A * (1 - t)
            }
        }

        rl.BeginDrawing()
        
        rl.ClearBackground(rl.BLACK)

        rl.DrawRectangleRec(slider, rl.RAYWHITE)
        rl.DrawRectangleRec(slider_tab, rl.GRAY)

        rl.DrawRectangleLinesEx(button_rand, 3, DARKESTGRAY)
        rl.DrawText(button_rand_text, i32(button_rand.x) +  30, i32(button_rand.y) + 12, 20, DARKESTGRAY)

        rl.DrawCircleV(point_A, 20, rl.GOLD)
        rl.DrawCircleV(point_B, 20, rl.GOLD) 

        rl.DrawCircleV(point_I, 20, rl.BLUE) 

        rl.DrawText(t_display, 310, 50, 30, rl.RAYWHITE)

        rl.DrawText(draw_text_line_one, 20, 20, 20, DARKESTGRAY)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}