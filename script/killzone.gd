extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var game_manager: GameManager = get_tree().get_first_node_in_group("game_manager") as GameManager
	if game_manager != null:
		game_manager.damage_player()
