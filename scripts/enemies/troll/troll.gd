class_name Troll
extends Monster

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_troll_front_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		# Don't ever render in front of troll if there are sort locks, as it can result in weird
		# rendering and interactions with the climbable area.
		if player.sort_locks == 0:
			player.z_index = z_index + 1

func _on_troll_front_area_body_exited(body:Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.z_index = player.DEFAULT_SORT_INDEX

func _on_troll_back_area_body_entered(body:Node2D) -> void:
	if body is Player:
		var player: Player = body
		# When the player is in a "render behind troll" zone, count this area as a sort lock.
		player.z_index = player.DEFAULT_SORT_INDEX
		player.sort_locks += 1

func _on_troll_back_area_body_exited(body:Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.sort_locks -= 1

## The stomp attack from the troll gets called automatically at the end of the stomp animation?
func stomp() -> void:
	pass # TODO: Implement stomping logic to change state and handle the attack.
