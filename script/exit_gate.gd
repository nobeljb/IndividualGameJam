class_name ExitGate
extends Node2D

@onready var closed_sprite: Sprite2D = $ClosedSprite as Sprite2D
@onready var open_sprite: Sprite2D = $OpenSprite as Sprite2D
@onready var blocker_shape: CollisionShape2D = $Blocker/CollisionShape2D as CollisionShape2D

var _is_open := false


func _ready() -> void:
	set_open(false)


func set_open(value: bool) -> void:
	_is_open = value
	closed_sprite.visible = not value
	open_sprite.visible = value
	blocker_shape.set_deferred("disabled", value)


func _on_prompt_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var game_manager: GameManager = get_tree().get_first_node_in_group("game_manager") as GameManager
	if game_manager == null:
		return

	if _is_open:
		game_manager.finish_level()
	else:
		game_manager.set_context_prompt("Gerbang ini belum mau menyambutmu.")


func _on_prompt_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if not is_inside_tree():
		return

	var tree: SceneTree = get_tree()
	if tree == null:
		return

	var game_manager: GameManager = tree.get_first_node_in_group("game_manager") as GameManager
	if game_manager != null and not game_manager.has_level_finished():
		game_manager.clear_context_prompt()
