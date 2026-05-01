extends Control

const MAIN_SCENE_PATH := "res://scenes/Main.tscn"


func _ready() -> void:
	var game_flow: GameFlowState = get_node("/root/GameFlow") as GameFlowState
	if game_flow != null:
		game_flow.clear_end_result()
	$CenterContainer/PanelContainer/MarginContainer/VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
