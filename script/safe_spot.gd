extends Node2D

@onready var rest_charm: RigidBody2D = $RestCharm as RigidBody2D


func _ready() -> void:
	rest_charm.apply_central_impulse(Vector2(55.0, -95.0))
