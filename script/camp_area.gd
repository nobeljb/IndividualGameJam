extends Area2D

var _player_inside := false


func _process(_delta: float) -> void:
	if not _player_inside:
		return

	var game_manager: GameManager = get_tree().get_first_node_in_group("game_manager") as GameManager
	if game_manager == null or game_manager.has_level_finished():
		return

	if game_manager.can_craft_safe_spot():
		game_manager.set_context_prompt("Tempat ini terasa tenang. Tekan C untuk create safe spot.")
		if Input.is_action_just_pressed("craft_safe_spot"):
			game_manager.craft_safe_spot()
	elif game_manager.has_safe_spot():
		game_manager.set_context_prompt("Tempat singgah ini sudah siap.")
	else:
		game_manager.set_context_prompt("Tempat ini terasa tenang. Namun seperti ada yang ketinggalan.")


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	_player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	_player_inside = false
	var game_manager: GameManager = get_tree().get_first_node_in_group("game_manager") as GameManager
	if game_manager != null:
		game_manager.clear_context_prompt()
