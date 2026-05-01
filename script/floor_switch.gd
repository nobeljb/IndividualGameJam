extends Area2D

const NORMAL_TEXTURE := preload("res://assets/kenney_abstract-platformer/PNG/Other/buttonFloor.png")
const PRESSED_TEXTURE := preload("res://assets/kenney_abstract-platformer/PNG/Other/buttonFloor_pressed.png")

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D

var _is_pressed := false


func _ready() -> void:
	sprite.texture = NORMAL_TEXTURE


func _on_body_entered(body: Node2D) -> void:
	if not _can_press_switch(body):
		return

	call_deferred("_sync_pressed_state")


func _on_body_exited(body: Node2D) -> void:
	if not _can_press_switch(body):
		return

	call_deferred("_sync_pressed_state")


func _sync_pressed_state() -> void:
	if not is_inside_tree():
		return

	var should_be_pressed := false

	for overlapping_body_variant in get_overlapping_bodies():
		var overlapping_body: Node2D = overlapping_body_variant as Node2D
		if overlapping_body == null or not _can_press_switch(overlapping_body):
			continue

		should_be_pressed = true
		break

	if _is_pressed == should_be_pressed:
		return

	_is_pressed = should_be_pressed
	sprite.texture = PRESSED_TEXTURE if _is_pressed else NORMAL_TEXTURE

	var tree: SceneTree = get_tree()
	if tree == null:
		return

	var game_manager: GameManager = tree.get_first_node_in_group("game_manager") as GameManager
	if game_manager != null:
		game_manager.set_puzzle_solved(_is_pressed)


func _can_press_switch(body: Node2D) -> bool:
	return body.is_in_group("push_crate") or body.is_in_group("player")
