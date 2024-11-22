class_name TrollStateMachine
extends StateMachine

@export var troll: Troll

func _ready() -> void:
	# Set the Player reference in all children before setting up the rest of the state machine.
	for child in get_children():
		if child is TrollState:
			child.troll = troll
	
	super()