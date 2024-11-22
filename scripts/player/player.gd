class_name Player
extends CharacterBody2D

@export var animation_player: AnimationPlayer
@export var coyote_timer: Timer
@export var debug_label: Label
@export var input_buffer_timer: Timer
@export var sprite: Sprite2D
@export var state_machine: StateMachine

## Both of these signals are utilized in PlayerClimbState and connected to by Troll.
@warning_ignore("unused_signal") signal climbing(emitter: Node)
@warning_ignore("unused_signal") signal stopped_climbing(emitter: Node)

const DEFAULT_SORT_INDEX: int = 1
const JUMP_VELOCITY: float = -500.0
const JUMP_CLIP_VELOCITY: float = -250.0
const ONE_WAY_PLATFORM_COLLISION_LAYER: int = 2
const SPEED: float = 300.0

var buffered_input: StringName = "" # Inputs can be buffered for 200ms.
var can_climb: bool = false
var collide_one_way: bool = true
var mount_velocity: Vector2 = Vector2.ZERO # Velocity of a moving mount, such as a Troll.
var mounted: bool = false
var sort_locks: int = 0 # Used to prevent updating the player z_index. Count of number of areas preventing sorting.

func _process(_delta) -> void:
	debug_label.text = "Current State: %s\nVelocity: %s\nBuffered Input: %s\nCurrent Animation: %s\nCan Climb: %s\nMounted: %s\nMount Velocity: %s" % \
		[state_machine.current_state.state_name, velocity, buffered_input, animation_player.current_animation, can_climb, mounted, mount_velocity]

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
	set_collision_mask_value(ONE_WAY_PLATFORM_COLLISION_LAYER, collide)