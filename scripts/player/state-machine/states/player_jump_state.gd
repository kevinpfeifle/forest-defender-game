class_name PlayerJumpState
extends PlayerState

func _ready() -> void:
	state_name = "jump"

func enter(args: Array) -> void:
	super(args)
	player.animation_player.play("jump")
	player.velocity.y = player.JUMP_VELOCITY

func physics_update(delta) -> void:
	super(delta)
	
	if Input.is_action_just_pressed("player_jump"):
		# There is no double-jumping, so buffer the jump and start the timer.
		player.input_buffer_timer.start()
		player.buffered_input = "jump"

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var direction: float = Input.get_axis("player_left", "player_right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)