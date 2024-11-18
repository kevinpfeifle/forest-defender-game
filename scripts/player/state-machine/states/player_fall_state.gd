class_name PlayerFallState
extends PlayerState

var grace_jump: bool = false

func _ready() -> void:
	state_name = "fall"

## Args[0] should be the name of the previous state.
func enter(args: Array) -> void:
	# Handle Coyote Time if this is a natural fall.
	if args[0] != "jump":
		player.coyote_timer.timeout.connect(_on_coyote_timer_timeout)
		player.coyote_timer.start()
		grace_jump = true

func exit() -> void:
	player.coyote_timer.stop()
	player.coyote_timer.timeout.disconnect(_on_coyote_timer_timeout)
	grace_jump = false

## Fall state overrides the default state change logic due to coyote time interactions with jumping.
func physics_update(delta) -> void:
	super(delta)
	
	var attempted_jump: bool = Input.is_action_just_pressed("player_jump")
	if attempted_jump && grace_jump:
		transition.emit("jump", [state_name])
		grace_jump = false
		player.coyote_timer.stop()
	
	# Handling falling if the state doesn't change.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var direction: float = Input.get_axis("player_left", "player_right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)

func _on_coyote_timer_timeout() -> void:
	player.animation_player.play("fall") # Play the fall animation once we are sure we won't jump.
	grace_jump = false