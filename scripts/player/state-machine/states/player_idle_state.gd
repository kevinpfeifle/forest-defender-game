class_name PlayerIdleState
extends PlayerState

func _ready() -> void:
	state_name = "idle"

func enter(_args: Array) -> void:
	if player.velocity != Vector2(0, 0):
		player.velocity = Vector2(0, 0)
	player.animation_player.play("idle")