
icon:
	@pnpm tauri icon public/sox.png
start:
	@pnpm tauri dev
build:
	@TAURI_PRIVATE_KEY=~/.tauri/vess.key TAURI_KEY_PASSWORD=1988 pnpm tauri build
opz:
	@upx --ultra-brute src-tauri/target/release/bundle/macos/Sox.app/Contents/macOS/Sox
cp:
	@cp -R src-tauri/target/release/bundle/macos/Sox.app /Applications
.PHONY: icon build opz