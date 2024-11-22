class_name PlayerIdleState
extends PlayerState

func _ready() -> void:
	state_name = "idle"

func enter(args: Array) -> void:
	super(args)
	if !active:
		return
	
	if !skip_state:
		player.animation_player.queue("idle")

func physics_update(delta) -> void:
	super(delta)
	if !active:
		return

	if player.mounted:
		player.velocity = player.mount_velocity