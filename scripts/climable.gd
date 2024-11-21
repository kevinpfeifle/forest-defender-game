class_name Climbable
extends Area2D

func _ready() -> void:
	var level: Node = find_level(self)
	if level:
		level.register_climbable(self)
	else:
		push_warning("Level node not found in the scene tree!")

func find_level(node: Node) -> Node:
	if node == null:
		return null
	if node.has_method("register_climbable"):
		return node
	return find_level(node.get_parent())