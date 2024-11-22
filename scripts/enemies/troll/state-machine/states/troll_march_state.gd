class_name TrollMarchState
extends TrollState

func enter(_args):
	troll.animation_player.play("move")

func physics_update(delta) -> void:
	super(delta)
	if !active:
		return

	var destination: Vector2 = troll.final_target.global_position
	var direction: Vector2 = (destination - troll.position).normalized()
	troll.velocity = direction * troll.SPEED
	if troll.position.distance_to(destination) < 1.0:
		troll.velocity = Vector2.ZERO 
		troll.target_arrived = true

	troll.set_facing_direction()

	if troll.has_rider:
		troll.rider.mount_velocity = troll.velocity