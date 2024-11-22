class_name TrollIdleState
extends TrollState

func enter(_args: Array) -> void:
	troll.animation_player.play("idle")