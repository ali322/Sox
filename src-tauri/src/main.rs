// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

mod command;
mod menu;
mod sysproxy;

fn main() {
    let mut builder = tauri::Builder::default();
    builder = command::apply_command(builder);
    builder = menu::apply_menu(builder);
    builder
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
