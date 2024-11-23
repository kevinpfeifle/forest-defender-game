class_name TrollAttackState
extends TrollState

@export var attack_area: Area2D

const DAMAGE = 2
const POWER = 100

func _ready() -> void:
	state_name = "attack"

func enter(args: Array) -> void:
	super(args)
	troll.animation_player.play("attack_ahead")

func physics_update(_delta) -> void:
	pass

func attack() -> void:
	if attack_area.has_overlapping_bodies():
		var bodies: Array[Node2D] = attack_area.get_overlapping_bodies()
		for body in bodies:
			if body is Player:
				var player: Player = body
				var direction_x: float = troll.sprite.scale.x * -1
				var direction_y: float
				if player.global_position.y >= troll.center_of_mass.global_position.y:
					direction_y = 1
				else:
					direction_y = -1
				player.health_component.damage(DAMAGE, troll, POWER, direction_x, direction_y)
			elif body is ForestTree:
				pass # TODO: Handle tree cutting here!