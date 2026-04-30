class_name PushCrate
extends CharacterBody2D

@export var push_speed: float = 180.0
@export var push_acceleration: float = 1800.0
@export var friction: float = 900.0
@export var gravity: float = 900.0
@export var push_deadzone: float = 1.0

var requested_push_x: float = 0.0


func _ready() -> void:
	add_to_group("push_crate")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	var target_velocity_x: float = 0.0

	if abs(requested_push_x) > push_deadzone:
		target_velocity_x = clampf(requested_push_x, -push_speed, push_speed)

	var next_velocity: Vector2 = velocity
	if abs(target_velocity_x) > 0.0:
		next_velocity.x = move_toward(next_velocity.x, target_velocity_x, push_acceleration * delta)
	else:
		next_velocity.x = move_toward(next_velocity.x, 0.0, friction * delta)

	velocity = next_velocity
	move_and_slide()
	requested_push_x = 0.0


func request_push(player_velocity_x: float) -> void:
	if abs(player_velocity_x) <= abs(requested_push_x):
		return

	requested_push_x = player_velocity_x


func _on_push_sensor_body_entered(_body: Node2D) -> void:
	pass


func _on_push_sensor_body_exited(_body: Node2D) -> void:
	pass
