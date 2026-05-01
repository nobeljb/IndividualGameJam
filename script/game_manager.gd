class_name GameManager
extends Node

const SAFE_SPOT_SCENE := preload("res://scenes/safe_spot.tscn")

@export var starting_lives := 3
@export var stars_needed_for_camp := 3

var stars := 0
var lives := 0
var checkpoint_active := false
var puzzle_solved := false
var level_finished := false
var respawning := false
var context_prompt := ""
var spawn_position := Vector2.ZERO

@onready var root: Node2D = get_parent() as Node2D
@onready var player: CharacterBody2D = root.get_node("Player") as CharacterBody2D
@onready var hud: CanvasLayer = root.get_node("HUD") as CanvasLayer
@onready var stars_label: Label = hud.get_node("StatsPanel/MarginContainer/VBoxContainer/StarsLabel") as Label
@onready var lives_label: Label = hud.get_node("StatsPanel/MarginContainer/VBoxContainer/LivesLabel") as Label
@onready var camp_label: Label = hud.get_node("StatsPanel/MarginContainer/VBoxContainer/CampLabel") as Label
@onready var objective_label: Label = hud.get_node("StatsPanel/MarginContainer/VBoxContainer/ObjectiveLabel") as Label
@onready var prompt_panel: PanelContainer = hud.get_node("PromptPanel") as PanelContainer
@onready var prompt_label: Label = hud.get_node("PromptPanel/MarginContainer/PromptLabel") as Label


func _ready() -> void:
	add_to_group("game_manager")
	lives = starting_lives
	spawn_position = player.global_position
	var music_player: MusicPlayer = get_node("/root/Music") as MusicPlayer
	if music_player != null:
		music_player.play_default_theme()
	update_hud()


func add_point() -> void:
	add_star()


func add_star() -> void:
	if level_finished:
		return

	stars += 1
	update_hud()


func can_craft_safe_spot() -> bool:
	return stars >= stars_needed_for_camp and not checkpoint_active and not level_finished


func craft_safe_spot() -> void:
	if not can_craft_safe_spot():
		return

	checkpoint_active = true
	var safe_spot: Node2D = SAFE_SPOT_SCENE.instantiate() as Node2D
	var camp_spawn: Marker2D = root.get_node("CampSpawn") as Marker2D
	root.add_child(safe_spot)
	safe_spot.global_position = camp_spawn.global_position
	set_checkpoint(camp_spawn.global_position + Vector2(0, -36))
	set_context_prompt("Tempat singgah ini kini bisa kau andalkan.")
	update_hud()


func set_checkpoint(new_position: Vector2) -> void:
	spawn_position = new_position


func damage_player() -> void:
	if level_finished or respawning:
		return

	lives -= 1
	update_hud()
	if lives <= 0:
		_show_result(false)
		return

	respawn_player()


func respawn_player() -> void:
	respawning = true
	player.set_controls_enabled(false)
	player.reset_motion()

	await get_tree().create_timer(0.35).timeout

	player.global_position = spawn_position
	player.reset_motion()
	player.set_controls_enabled(true)
	respawning = false


func set_puzzle_solved(is_solved: bool = true) -> void:
	if level_finished or puzzle_solved == is_solved:
		return

	puzzle_solved = is_solved
	var exit_gate: ExitGate = root.get_node("ExitGate") as ExitGate
	if exit_gate != null:
		exit_gate.set_open(puzzle_solved)
	if puzzle_solved:
		clear_context_prompt()
	update_hud()


func finish_level() -> void:
	if level_finished or not puzzle_solved:
		return

	_show_result(true)


func set_context_prompt(text: String) -> void:
	if level_finished:
		return

	context_prompt = text
	update_hud()


func clear_context_prompt() -> void:
	if level_finished:
		return

	context_prompt = ""
	update_hud()


func has_safe_spot() -> bool:
	return checkpoint_active


func has_level_finished() -> bool:
	return level_finished


func update_hud() -> void:
	stars_label.text = "Fragmen: %d / %d" % [stars, stars_needed_for_camp]
	lives_label.text = "Nyawa: %d" % lives
	camp_label.text = "Safe Spot: %s" % ("Aktif" if checkpoint_active else "Belum aktif")
	objective_label.text = "Tujuan: %s" % _get_objective_text()
	prompt_label.text = context_prompt
	prompt_panel.visible = not context_prompt.is_empty()


func _get_objective_text() -> String:
	if not checkpoint_active:
		if stars < stars_needed_for_camp:
			return "Ada sesuatu yang berguna tersebar di awal perjalanan."
		return "Tempat singgah sepertinya menarik."
	if not puzzle_solved:
		return "Masih ada sesuatu yang menahan langkahmu."
	return "Akhir dari perjalanan telah terbuka."


func _show_result(did_win: bool) -> void:
	level_finished = true
	respawning = true
	player.set_controls_enabled(false)
	context_prompt = ""

	var result_title: String = ""
	var result_body: String = ""

	if did_win:
		var music_player: MusicPlayer = get_node("/root/Music") as MusicPlayer
		if music_player != null:
			music_player.play_victory_theme()
		result_title = "Nginep Tercapai"
		result_body = "Perjalananmu akhirnya menemukan ritmenya sendiri, dan ujung jalan pun menyambutmu."
	else:
		result_title = "Perjalanan Berakhir"
		if checkpoint_active:
			result_body = "Langkahmu terhenti sejenak, tetapi tempat singgah terakhir masih menunggumu."
		else:
			result_body = "Perjalananmu terhenti sebelum menemukan tempat yang benar-benar aman."

	var game_flow: GameFlowState = get_node("/root/GameFlow") as GameFlowState
	if game_flow != null:
		game_flow.set_end_result(did_win, stars, lives, checkpoint_active, result_title, result_body)
		game_flow.open_end_screen()
