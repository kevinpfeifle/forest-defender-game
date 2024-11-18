class_name Player
extends CharacterBody2D

@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

func _process(_delta) -> void:
	if velocity.x > 0:
		sprite.scale.x = -1
	elif velocity.x < 0:
		sprite.scale.x = 1

func _physics_process(_delta: float) -> void:
	move_and_slide()
