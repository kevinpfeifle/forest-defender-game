class_name PlayerClimbState
extends PlayerState

func _ready() -> void:
	state_name = "climb"

func enter(args) -> void:
	super(args)
	player.sprite.scale.y = player.sprite.scale.x
	player.sprite.scale.x = 1
	player.climbing.emit(player)
	if args[0] == "idle" || args[0] == "move":
		player.animation_player.play("climb_start_ground", -1, 2)
		player.animation_player.queue("climb")
	elif args[0] == "jump" || args[0] == "fall":
		player.animation_player.play("climb_start_fall", -1 , 2)
		player.animation_player.queue("climb")

func exit(new_state: StringName) -> void:
	if new_state == "idle":
		player.animation_player.stop()
	else:
		player.animation_player.play("fall_start_ground")
	# While rotated 90 degrees, the x and y were flipped. Set it back to normal.
	player.sprite.scale.x = player.sprite.scale.y
	player.sprite.scale.y = 1
	player.stopped_climbing.emit(player)

func physics_update(delta) -> void:
	super(delta)
	if !active:
		return
	
	var direction_x: float = Input.get_axis("player_left", "player_right")
	var direction_y: float = Input.get_axis("player_up", "player_down")

	if direction_x:
		player.velocity.x = direction_x * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)

	if direction_y:
		player.velocity.y = direction_y * player.SPEED
		# Update the facing of up/down for climbing direction.
		if player.velocity.y > 0:
			player.sprite.scale.x = -1
		elif player.velocity.y < 0:
			player.sprite.scale.x = 1
	else:
		player.velocity.y = move_toward(player.velocity.y, 0, player.SPEED)

	if player.mounted:
		player.velocity += player.mount_velocity

	if player.is_on_floor() && player.velocity.y > 0:
		player.velocity = Vector2.ZERO 
		transition.emit("idle", [state_name])
		return

	if player.velocity == Vector2.ZERO :
		player.animation_player.pause()
	else:
		player.animation_player.play("climb")
