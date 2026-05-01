class_name GameFlowState
extends Node

const MAIN_SCENE_PATH := "res://scenes/Main.tscn"
const MENU_SCENE_PATH := "res://scenes/MainMenu.tscn"
const END_SCENE_PATH := "res://scenes/EndScreen.tscn"

var did_win: bool = false
var stars_collected: int = 0
var lives_left: int = 0
var safe_spot_built: bool = false
var summary_title: String = "Perjalanan Belum Dimulai"
var summary_body: String = "Masuk ke dunia Beyond Nginep's End untuk memulai perjalananmu."


func set_end_result(new_did_win: bool, new_stars_collected: int, new_lives_left: int, new_safe_spot_built: bool, new_summary_title: String, new_summary_body: String) -> void:
	did_win = new_did_win
	stars_collected = new_stars_collected
	lives_left = new_lives_left
	safe_spot_built = new_safe_spot_built
	summary_title = new_summary_title
	summary_body = new_summary_body


func clear_end_result() -> void:
	did_win = false
	stars_collected = 0
	lives_left = 0
	safe_spot_built = false
	summary_title = "Perjalanan Belum Dimulai"
	summary_body = "Masuk ke dunia Beyond Nginep's End untuk memulai perjalananmu."


func open_end_screen() -> void:
	var tree: SceneTree = get_tree()
	if tree == null:
		return

	tree.call_deferred("change_scene_to_file", END_SCENE_PATH)


func restart_level() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)


func open_main_menu() -> void:
	clear_end_result()
	get_tree().change_scene_to_file(MENU_SCENE_PATH)
