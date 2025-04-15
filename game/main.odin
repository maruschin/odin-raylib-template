#+feature dynamic-literals

package game

import "base:runtime"
import "core:c"
import "core:fmt"
import "core:mem"
import rl "vendor:raylib"
import wasm "wasm"

when (ODIN_ARCH == .wasm32) | (ODIN_ARCH == .wasm64p32) {
	@(private = "file")
	web_context: runtime.Context

	@(private = "file")
	game: Game

	@(export)
	main_start :: proc "c" () {
		context = runtime.default_context()
		context.allocator = wasm.emscripten_allocator()
		runtime.init_global_temporary_allocator(1 * mem.Megabyte)
		context.logger = wasm.create_emscripten_logger()
		web_context = context
		game = Game__init()
	}

	@(export)
	main_update :: proc "c" () -> bool {
		context = web_context
		Game__controller(&game)
		return Game__should_run(&game)
	}

	@(export)
	main_end :: proc "c" () {
		context = web_context
		Game__close(&game)
	}

	@(export)
	web_window_size_changed :: proc "c" (w: c.int, h: c.int) {
		context = web_context
		Game__parent_window_size_changed(int(w), int(h))
	}

	main :: proc() {}
}


when (ODIN_ARCH == .arm64) | (ODIN_ARCH == .amd64) {
	main :: proc() {
		when ODIN_DEBUG {
			track: mem.Tracking_Allocator
			mem.tracking_allocator_init(&track, context.allocator)
			context.allocator = mem.tracking_allocator(&track)

			defer {
				if len(track.allocation_map) > 0 {
					fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
					for _, entry in track.allocation_map {
						fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
					}
				}
				if len(track.bad_free_array) > 0 {
					fmt.eprintf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
					for entry in track.bad_free_array {
						fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
					}
				}
				mem.tracking_allocator_destroy(&track)
			}
		}

		game := Game__init()
		for Game__should_run(&game) {
			Game__controller(&game)
		}
		Game__close(&game)
	}
}
