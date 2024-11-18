class_name PlayerMoveState
extends PlayerState

func _ready() -> void:
	state_name = "move"

func enter(args: Array) -> void:
	super(args)
	player.animation_player.play("move")

func physics_update(delta) -> void:
	super(delta)
	
	var direction: float = Input.get_axis("player_left", "player_right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)