extends Area2D

const NORMAL_TEXTURE := preload("res://assets/kenney_abstract-platformer/PNG/Other/buttonFloor.png")
const PRESSED_TEXTURE := preload("res://assets/kenney_abstract-platformer/PNG/Other/buttonFloor_pressed.png")

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D

var _activated := false


func _ready() -> void:
	sprite.texture = NORMAL_TEXTURE


func _on_body_entered(body: Node2D) -> void:
	if _activated or not body.is_in_group("push_crate"):
		return

	_activated = true
	sprite.texture = PRESSED_TEXTURE

	var game_manager: GameManager = get_tree().get_first_node_in_group("game_manager") as GameManager
	if game_manager != null:
		game_manager.set_puzzle_solved()
