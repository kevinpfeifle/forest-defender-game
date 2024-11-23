class_name PlayerDeath
extends PlayerState

func _ready() -> void:
	state_name = "death"

func enter(args: Array) -> void:
	super(args)
	player.animation_player.play("death")

## Override the inherited version that handles state checking.
func physics_update(delta: float) -> void:
	## Gravity is the only condition we care about since player is dead.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta