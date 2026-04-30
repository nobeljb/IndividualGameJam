extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D

@export var gravity = 900.0
@export var walk_speed = 200
@export var crouch_speed = 100
@export var jump_speed = -400
@export var dash_speed = 600
@export var dash_time = 0.2
@export var max_jumps = 2

var jump_count = 0
var is_dashing = false
var dash_timer = 0.0

var last_left_tap = 0.0
var last_right_tap = 0.0
var double_tap_time = 0.25

var facing_direction = 1   # 1 = kanan, -1 = kiri
var controls_enabled = true


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta):
	if not controls_enabled:
		return

	# GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.y > 100:
			play_anim("land")
		jump_count = 0

	# DOUBLE JUMP
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		if jump_count == 0:
			play_anim("jump")
		else:
			play_anim("double_jump")
		jump_count += 1

	# Variable jump height
	if Input.is_action_just_released("ui_up") and velocity.y < 0:
		velocity.y *= 0.5

	# CROUCH
	var current_speed: float = walk_speed
	var is_crouching = false
	if Input.is_action_pressed("ui_down") and is_on_floor():
		current_speed = crouch_speed
		is_crouching = true

	# DASH (DOUBLE TAP)
	var time_now: float = Time.get_ticks_msec() / 1000.0

	if Input.is_action_just_pressed("ui_left"):
		if time_now - last_left_tap < double_tap_time:
			start_dash(-1)
		last_left_tap = time_now

	if Input.is_action_just_pressed("ui_right"):
		if time_now - last_right_tap < double_tap_time:
			start_dash(1)
		last_right_tap = time_now

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# MOVEMENT
	var attempted_horizontal_velocity: float = velocity.x
	if not is_dashing:
		if Input.is_action_pressed("ui_left"):
			velocity.x = -current_speed
			facing_direction = -1
		elif Input.is_action_pressed("ui_right"):
			velocity.x = current_speed
			facing_direction = 1
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)
		attempted_horizontal_velocity = velocity.x

	move_and_slide()
	push_crate_collisions(attempted_horizontal_velocity)

	update_animation(is_crouching)

# DASH FUNCTION
func start_dash(direction):
	is_dashing = true
	dash_timer = dash_time
	facing_direction = direction
	velocity.x = direction * dash_speed
	play_anim("dash")

# ANIMATION STATE LOGIC
func update_animation(is_crouching):
	# Mirror sprite sesuai arah
	anim.flip_h = facing_direction == -1

	if is_dashing:
		return

	if not is_on_floor():
		if velocity.y < 0:
			play_anim("jump")
		else:
			play_anim("fall")
	elif is_crouching:
		play_anim("crouch")
	elif abs(velocity.x) > 10:
		play_anim("run")
	else:
		play_anim("idle")

# SAFE PLAY ANIMATION
func play_anim(_name):
	if anim.animation != _name and anim.sprite_frames.has_animation(_name):
		anim.play(_name)


func set_controls_enabled(enabled: bool) -> void:
	controls_enabled = enabled
	if not enabled:
		reset_motion()


func reset_motion() -> void:
	velocity = Vector2.ZERO
	is_dashing = false
	dash_timer = 0.0


func push_crate_collisions(horizontal_velocity: float) -> void:
	if abs(horizontal_velocity) < 0.1:
		return

	for collision_index in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(collision_index)
		if abs(collision.get_normal().x) < 0.7:
			continue

		var crate: PushCrate = collision.get_collider() as PushCrate
		if crate == null:
			continue

		crate.request_push(horizontal_velocity)
