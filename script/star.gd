extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var game_manager: GameManager = get_tree().get_first_node_in_group("game_manager") as GameManager
	if game_manager != null:
		game_manager.add_star()
	animation_player.play("pick_up")
