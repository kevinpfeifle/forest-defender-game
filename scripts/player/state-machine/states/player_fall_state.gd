class_name PlayerFallState
extends PlayerState

func _ready() -> void:
	state_name = "fall"

func enter(_args: Array) -> void:
	player.animation_player.play("fall")

func physics_update(delta) -> void:
	super(delta)
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var direction: float = Input.get_axis("player_left", "player_right")
	if direction:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)