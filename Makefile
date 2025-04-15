OUT_DIR := build
ODIN_PATH := $(shell odin root)


WASM_OUT_DIR := $(OUT_DIR)_wasm
WASM_FLAGS := -sUSE_GLFW=3 -sWASM_BIGINT -sWARN_ON_UNDEFINED_SYMBOLS=0 -sASSERTIONS --shell-file game/wasm/index.html --preload-file assets
WASM_FILES := $(WASM_OUT_DIR)/game.wasm.o game/wasm/libraylib.a

run:
	mkdir -p $(OUT_DIR)
	odin run game -debug -out:$(OUT_DIR)/game

build:
	mkdir -p $(OUT_DIR)
	odin build game -out:$(OUT_DIR)/game

build_wasm:
	mkdir -p $(WASM_OUT_DIR)
	odin build game -target:js_wasm32 -build-mode:obj -define:RAYLIB_WASM_LIB=env.o -strict-style -out:$(WASM_OUT_DIR)/game
	cp $(ODIN_PATH)core/sys/wasm/js/odin.js $(WASM_OUT_DIR)
	emcc -o $(WASM_OUT_DIR)/index.html $(WASM_FILES) $(WASM_FLAGS)
	rm $(WASM_OUT_DIR)/game.wasm.o
