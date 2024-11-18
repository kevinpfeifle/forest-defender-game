class_name PlayerState
extends State

## PlayerState is an abstract class. It shouldn't be attached to any Nodes.
## All instances of PlayerState need a reference to the player. It is set by the Player State Machine.

var player: Player

func physics_update(_delta: float) -> void:
	var new_state = _check_for_state_change()
	if new_state != state_name && new_state != "":
		transition.emit(new_state, [])

func _check_for_state_change() -> StringName:
	if not player.is_on_floor():
		return "fall"
	elif Input.is_action_just_pressed("player_jump") and player.is_on_floor():
		return "jump"
	elif Input.get_axis("player_left", "player_right") != 0:
		return "move"
	elif player.velocity == Vector2(0, 0):
		return "idle"
	return ""