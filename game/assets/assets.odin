package assets

import rl "vendor:raylib"


Assets :: [Asset]rl.Texture2D

Asset :: enum {
	Default,
}

AssetDescription :: struct {
	num_frames:   int,
	frame_length: f32,
}

ASSETS_PATH: [Asset]string : {
	.Default = "default.png",
}
