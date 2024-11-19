class_name PlayerStateMachine
extends StateMachine

@export var player: Player

func _ready() -> void:
	# Set the Player reference in all children before setting up the rest of the state machine.
	for child in get_children():
		if child is PlayerState:
			child.player = player
	
	super()