class_name Player
extends CharacterBody2D

@export var animation_player: AnimationPlayer
@export var coyote_timer: Timer
@export var debug_label: Label
@export var input_buffer_timer: Timer
@export var sprite: Sprite2D
@export var state_machine: StateMachine

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

func _process(_delta) -> void:
	if velocity.x > 0:
		sprite.scale.x = -1
	elif velocity.x < 0:
		sprite.scale.x = 1

	debug_label.text = "Current State: %s\nVelocity: %s" % \
		[state_machine.current_state.state_name, velocity]

func _physics_process(_delta: float) -> void:
	move_and_slide()