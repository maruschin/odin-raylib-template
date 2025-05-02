package assets

import "core:fmt"
import rl "vendor:raylib"


load :: proc() -> (textures: Assets) {
	for path, asset in ASSETS_PATH {
		textures[asset] = rl.LoadTexture(fmt.ctprintf("assets/%s", path))
	}
	return
}

unload :: proc(assets: Assets) {
	for asset in assets do rl.UnloadTexture(asset)
}
