class_name Level
extends Node2D

var climbables: Array[Area2D] = []

func register_climbable(climable: Area2D) -> void:
	climbables.append(climable)
	climable.body_entered.connect(_on_climable_body_entered)
	climable.body_exited.connect(_on_climable_body_exited)

func _on_climable_body_entered(body: Node2D):
	if body is Player:
		var player: Player = body
		player.can_climb = true
		

func _on_climable_body_exited(body: Node2D):
	if body is Player:
		var player: Player = body
		player.can_climb = false