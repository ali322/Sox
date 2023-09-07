VERSION := "1.5.0-beta.3"

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
sync:
	@wget https://github.com/SagerNet/sing-box/releases/download/v$(VERSION)/sing-box-$(VERSION)-darwin-amd64.tar.gz
	@tar zxvf sing-box-$(VERSION)-darwin-amd64.tar.gz -C src-tauri/bin
	@mv src-tauri/bin/sing-box-$(VERSION)-darwin-amd64/sing-box src-tauri/bin/sing-box-x86_64-apple-darwin
	@rm -rf src-tauri/bin/sing-box-$(VERSION)-darwin-amd64
	@rm -rf sing-box-$(VERSION)-darwin-amd64.tar.gz
sync-win:
	@wget https://github.com/SagerNet/sing-box/releases/download/v$(VERSION)/sing-box-$(VERSION)-windows-amd64.zip
	@unzip -d src-tauri/bin sing-box-$(VERSION)-windows-amd64.zip
	@mv src-tauri/bin/sing-box-$(VERSION)-windows-amd64/sing-box.exe src-tauri/bin/sing-box-x86_64-pc-windows-msvc.exe
	@rm -rf src-tauri/bin/sing-box-$(VERSION)-windows-amd64
	@rm -rf sing-box-$(VERSION)-windows-amd64.zip
sync-linux:
	@wget https://github.com/SagerNet/sing-box/releases/download/v$(VERSION)/sing-box-$(VERSION)-linux-amd64.tar.gz
	@tar zxvf sing-box-$(VERSION)-linux-amd64.tar.gz -C src-tauri/bin
	@mv src-tauri/bin/sing-box-$(VERSION)-linux-amd64/sing-box src-tauri/bin/sing-box-x86_64-unknown-linux-gnu
	@rm -rf src-tauri/bin/sing-box-$(VERSION)-linux-amd64
	@rm -rf sing-box-$(VERSION)-linux-amd64.tar.gz
.PHONY: icon build opz