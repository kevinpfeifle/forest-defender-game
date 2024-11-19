class_name PlayerState
extends State

## PlayerState is an abstract class. It shouldn't be attached to any Nodes.

## skip_state allows us to block state logic in the event we are routed to a buffered input instead.
## This is needed because there will be a frame or so where we enter that state that would have occurred
## before we can enter the buffered one.
var skip_state: bool = false

## All instances of PlayerState need a reference to the player. It is set by the Player State Machine.
var player: Player

## The buffer_map dictates what states a buffered input can fire from.
var buffer_map: Dictionary = {
	"jump": ["idle", "move"]
}

func enter(_args) -> void:
	skip_state = false

	# Check if there is a buffered input we should transition to instead of this state.
	if player.buffered_input != "" && buffer_map[player.buffered_input].has(state_name):
		var new_state = player.buffered_input
		player.input_buffer_timer.stop()
		player.buffered_input = ""
		skip_state = true
		transition.emit(new_state, [state_name])

## Default abstract logic simply handles state changes.
func physics_update(_delta: float) -> void:
	var new_state = _check_for_state_change()
	if new_state != state_name && new_state != "":
		transition.emit(new_state, [state_name]) # All states get the previous state sent as first arg.

## Returns the name of the next state based on user input actions. Empty string = no change.
func _check_for_state_change() -> StringName:
	if not player.is_on_floor() && player.velocity.y >= 0:
		return "fall"
	elif player.is_on_floor() && Input.is_action_just_pressed("player_jump"):
		return "jump"
	elif player.is_on_floor() && Input.get_axis("player_left", "player_right") != 0:
		return "move"
	elif player.velocity == Vector2(0, 0):
		return "idle"
	return ""