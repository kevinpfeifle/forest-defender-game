class_name PlayerState
extends State

## PlayerState is an abstract class. It shouldn't be attached to any Nodes.
## All instances of PlayerState need a reference to the player. It is set by the Player State Machine.

var player: Player

## Default abstract logic simply handles state changes.
func physics_update(_delta: float) -> void:
	var new_state = _check_for_state_change()
	if new_state != state_name && new_state != "":
		transition.emit(new_state, [state_name]) # All states get the previous state sent as first arg.

## Returns the name of the next state based on user input actions. Empty string = no change.
func _check_for_state_change() -> StringName:
	if Input.is_action_just_pressed("player_jump"):
		return "jump"
	elif not player.is_on_floor():
		return "fall"
	elif Input.get_axis("player_left", "player_right") != 0:
		return "move"
	elif player.velocity == Vector2(0, 0):
		return "idle"
	return ""