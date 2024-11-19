class_name PlayerMoveState
extends PlayerState

func _ready() -> void:
	state_name = "move"

func enter(args: Array) -> void:
	super(args)
	
	if !skip_state:
		player.animation_player.play("move_start", -1, 2)
		player.animation_player.queue("move")

func exit(new_state: StringName) -> void:
	if new_state == "idle":
		player.animation_player.play("move_stop", -1, 2)

func physics_update(delta) -> void:
	super(delta)
	
	var direction: float = Input.get_axis("player_left", "player_right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)