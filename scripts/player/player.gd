class_name Player
extends CharacterBody2D

@export var animation_player: AnimationPlayer
@export var coyote_timer: Timer
@export var debug_label: Label
@export var input_buffer_timer: Timer
@export var sprite: Sprite2D
@export var state_machine: StateMachine

const DEFAULT_SORT_INDEX: int = 1
const JUMP_VELOCITY: float = -500.0
const JUMP_CLIP_VELOCITY: float = -250.0
const SPEED: float = 300.0

var buffered_input: StringName = "" # Inputs can be buffered for 200ms.
var can_climb: bool = false
var collide_one_way: bool = true
var sort_locks: int = 0 # Used to prevent updating the player z_index. Count of number of areas preventing sorting.

func _process(_delta) -> void:
	debug_label.text = "Current State: %s\nVelocity: %s\nBuffered Input: %s\nCurrent Animation: %s\nCan Climb: %s" % \
		[state_machine.current_state.state_name, velocity, buffered_input, animation_player.current_animation, can_climb]

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_down"):
		# Ignore collisions with one-way platforms
		collide_one_way = false
		set_one_way_collision_detection(collide_one_way)
	elif Input.is_action_just_released("player_down"):
		# Re-enable collisions with one-way platforms
		collide_one_way = true
		set_one_way_collision_detection(collide_one_way)

	move_and_slide()

func _on_input_buffer_timer_timeout() -> void:
	buffered_input = "" # Clear the input buffer it isn't consumed in 200ms.

func set_facing_direction() -> void:
	if velocity.x > 0:
		sprite.scale.x = -1
	elif velocity.x < 0:
		sprite.scale.x = 1

func set_one_way_collision_detection(collide: bool) -> void:
	# Layer 2 is the one-way platform layer.
	set_collision_mask_value(2, collide)