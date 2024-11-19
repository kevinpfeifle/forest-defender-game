class_name PlayerJumpState
extends PlayerState

func _ready() -> void:
	state_name = "jump"

func enter(args: Array) -> void:
	super(args)
	# player.animation_player.animation_finished.connect(_on_animation_finished)
	player.animation_player.play("jump_start", -1, 2.5)
	player.animation_player.queue("jump_airborne")
	if Input.is_action_just_released("player_jump"):
		player.velocity.y = player.JUMP_CLIP_VELOCITY
	else:
		player.velocity.y = player.JUMP_VELOCITY

func exit(_new_state: StringName) -> void:
	player.animation_player.stop()

func physics_update(delta) -> void: 
	super(delta)

	if Input.is_action_just_released("player_jump") && player.velocity.y < player.JUMP_CLIP_VELOCITY:
		player.velocity.y = player.JUMP_CLIP_VELOCITY

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var direction: float = Input.get_axis("player_left", "player_right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)