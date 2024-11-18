class_name PlayerIdleState
extends PlayerState

func _ready() -> void:
	state_name = "idle"

func enter(args: Array) -> void:
	super(args)
	player.animation_player.play("idle")