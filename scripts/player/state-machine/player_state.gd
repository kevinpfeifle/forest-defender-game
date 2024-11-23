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

	# Connect to the hurt/death signals from the health component
	player.health_component.damaged.connect(_on_player_damaged)
	player.health_component.dead.connect(_on_player_death)

	# Check if there is a buffered input we should transition to instead of this state.
	if player.buffered_input != "" && buffer_map[player.buffered_input].has(state_name):
		var new_state = player.buffered_input
		player.input_buffer_timer.stop()
		player.buffered_input = ""
		skip_state = true
		transition.emit(new_state, [state_name])

func exit(_new_state: StringName) -> void:
	player.health_component.damaged.disconnect(_on_player_damaged)
	player.health_component.dead.disconnect(_on_player_death)

## Default abstract logic simply handles state changes.
func physics_update(_delta: float) -> void:
	if !active:
		return
	var new_state = _check_for_state_change()
	if new_state != state_name && new_state != "":
		transition.emit(new_state, [state_name]) # All states get the previous state sent as first arg.

## Returns the name of the next state based on user input actions. Empty string = no change.
func _check_for_state_change() -> StringName:
	if (player.is_on_floor() || state_name == "climb") && Input.is_action_just_pressed("player_jump"):
		return "jump"

	if player.can_climb && (state_name == "climb" || Input.is_action_pressed("player_up") || 
		(not player.is_on_floor() && Input.is_action_pressed("player_down"))):
		return "climb"

	if not player.is_on_floor() && player.velocity.y >= 0:
		return "fall"
	elif not player.is_on_floor() && (!player.can_climb && state_name == "climb"):
		return "fall"

	if player.is_on_floor() && Input.get_axis("player_left", "player_right") != 0:
		return "move"
	
	if (player.is_on_floor() && player.velocity == Vector2.ZERO) || player.mounted:
		return "idle"
	
	return ""

func _on_player_damaged(amount, source, power, direction_x, direction_y) -> void:
	active = false
	transition.emit("hurt", [state_name, amount, source, power, direction_x, direction_y])

func _on_player_death() -> void:
	active = false
	transition.emit("death", [state_name])