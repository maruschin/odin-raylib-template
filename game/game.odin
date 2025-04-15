package game
import "core:encoding/json"
import "core:os"
import rl "vendor:raylib"

PixelWindowHeight :: 180

Window :: struct {
	name:          cstring,
	width:         i32,
	height:        i32,
	fps:           i32,
	control_flags: rl.ConfigFlags,
}

Window__set :: proc(window: ^Window) {
	rl.InitWindow(window.width, window.height, window.name)
	rl.SetWindowState(window.control_flags)
	rl.SetTargetFPS(window.fps)
	rl.SetWindowPosition(200, 200)
}

Game :: struct {
	state:  GameState,
	camera: rl.Camera2D,
	run:    bool,
}

GameState :: enum {
	Menu,
	Play,
}

Game__init :: proc() -> Game {
	window := Window{"Game Template", 1280, 720, 60, rl.ConfigFlags{.WINDOW_RESIZABLE}}
	Window__set(&window)
	return {state = .Menu, run = true}
}

Game__controller :: proc(game: ^Game) {
	rl.BeginDrawing();defer rl.EndDrawing()
	rl.ClearBackground({110, 184, 168, 255})
}

Game__should_run :: proc(game: ^Game) -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			return false
		}
	}

	return game.run
}


Game__close :: proc(game: ^Game) {
	rl.CloseWindow()
}


Game__parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(i32(w), i32(h))
}
