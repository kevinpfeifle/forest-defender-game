class_name PlayerFallState
extends PlayerState

var air_time: float = 0.0
var coyote_connected: bool = false
var external_force: Vector2 = Vector2.ZERO
var grace_jump: bool = false

func _ready() -> void:
	state_name = "fall"

## Args[0] should be the name of the previous state.
func enter(args: Array) -> void:
	super(args)
	
	# Setup Coyote Time if this is a natural fall.
	if args[0] != "jump":
		player.coyote_timer.timeout.connect(_on_coyote_timer_timeout)
		player.coyote_timer.start()
		coyote_connected = true
		grace_jump = true
	else:
		player.animation_player.play("fall_start_jump")
		player.animation_player.queue("fall")
		grace_jump = false

	# Maintain horizontal momentum if this is knockback from an attack.
	if args[0] == "hurt":
		external_force = player.velocity

func exit(_new_state: StringName) -> void:
	air_time = 0.0
	player.animation_player.stop()
	
	# Teardown the coyote timer.
	if coyote_connected:
		player.coyote_timer.stop()
		player.coyote_timer.timeout.disconnect(_on_coyote_timer_timeout)
		coyote_connected = false
	grace_jump = false

## Fall state overrides the default state change logic due to coyote time interactions with jumping.
func physics_update(delta) -> void:
	super(delta)
	if !active:
		return
	
	var attempted_jump: bool = Input.is_action_just_pressed("player_jump")
	if attempted_jump && grace_jump:
		grace_jump = false
		player.coyote_timer.stop()
		transition.emit("jump", [state_name])
		return
	elif attempted_jump && !grace_jump:
		# Buffer the jump and start the timer.
		player.input_buffer_timer.start()
		player.buffered_input = "jump"
	
	# Handling falling if the state doesn't change. Gravity will get stronger the longer the fall.
	if not player.is_on_floor(): 
		player.velocity += player.get_gravity() * delta * (1.25 + air_time)
	air_time += delta

	var direction: float = Input.get_axis("player_left", "player_right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED - external_force.x)
		# TOOD: FIX THIS!
		# if external_force != null:
		# 	player.velocity.x += external_force.x


	player.set_facing_direction()

func _on_coyote_timer_timeout() -> void:
	player.animation_player.play("fall_start_ground")
	player.animation_player.queue("fall") # Play the fall animation once we are sure we won't jump.
	grace_jump = false