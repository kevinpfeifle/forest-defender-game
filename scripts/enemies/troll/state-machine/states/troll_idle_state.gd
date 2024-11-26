class_name TrollIdleState
extends TrollState

func _ready() -> void:
	state_name = "idle"

func enter(_args: Array) -> void:
	troll.animation_player.play("idle")

func physics_update(delta) -> void:
	super(delta)
	if !active:
		return

	if troll.has_rider:
		troll.rider.mount_velocity = troll.velocity