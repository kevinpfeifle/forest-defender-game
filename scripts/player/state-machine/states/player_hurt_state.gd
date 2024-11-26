class_name PlayerHurtState
extends PlayerState

# Need knockback, interuptions.

var damage_source: Node
var knockback_force: int
var knockback_direction: Vector2
var state_lock: bool = false

func _ready() -> void:
	state_name = "hurt"

func _on_hurt_timer_timeout() -> void:
	state_lock = false

## args[0] is the previous state, args[1] is the Node that hurt the player.
func enter(args: Array) -> void:
	super(args)
	state_lock = true

	player.animation_player.play("hurt")
	player.hurt_timer.timeout.connect(_on_hurt_timer_timeout)
	player.hurt_timer.start()

	damage_source = args[2]
	# if damage_source is CharacterBody2D:
	# 	var attacker: CharacterBody2D = damage_source
	knockback_force = args[3]
	knockback_direction = Vector2(args[4], args[5])
	player.velocity.x = knockback_direction.x * knockback_force * 5
	player.velocity.y = knockback_direction.y * knockback_force * 2.5

func physics_update(delta) -> void:
	# We only want to check for other states once the hurt lockout has finished.
	if !state_lock: 
		super(delta)

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
