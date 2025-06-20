#!/usr/bin/env bash

odin build src/main_wasm_bug.odin -file -target:js_wasm32 -no-entry-point -out:www/game.wasm -debug