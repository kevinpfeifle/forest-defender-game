class_name TrollState
extends State

## TrollState is an abstract class. It shouldn't be attached to any Nodes.

## All instances of TrollState need a reference to its troll. It is set by the Troll State Machine.
var troll: Troll

## Default abstract logic simply handles state changes.
func physics_update(_delta: float) -> void:
	if !active:
		return
	var new_state = _check_for_state_change()
	if new_state != state_name:
		transition.emit(new_state, [state_name]) # All states get the previous state sent as first arg.

## Returns the name of the next state based on areas and status. Empty string = no change.
func _check_for_state_change() -> StringName:
	if troll.velocity == Vector2.ZERO && troll.target_arrived:
		return "idle"
	
	return "march" # By default, if no other "desire" emerges, continue marching to the target.