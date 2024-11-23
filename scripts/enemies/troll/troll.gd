class_name Troll
extends Monster

@export var debug_label: Label 

@onready var center_of_mass: Marker2D = $CenterOfMass

const SPEED = 50

var has_rider: bool = false
var dynamic_children: Array[Node] # All the child nodes that need to flip when the sprite flips.
var rider: CharacterBody2D
var target_arrived: bool = false

func _ready() -> void:
	for child in get_children():
		if child is Sprite2D || child is Area2D || child is StaticBody2D:
			dynamic_children.append(child)

func _process(_delta) -> void:
	debug_label.text = "Velocity: %s" % [velocity]

func _physics_process(_delta: float) -> void:
	move_and_slide()

## Troll specific logic.
func set_facing_direction() -> void:
	var facing_direction: int
	if velocity.x > 0:
		facing_direction = -1
	elif velocity.x < 0:
		facing_direction = 1

	for child in dynamic_children:
		child.scale.x = facing_direction

## The stomp attack from the troll gets called automatically at the end of the stomp animation?
func stomp() -> void:
	pass # TODO: Implement stomping logic to change state and handle the attack.

## Signal connections to handle a "rider" on the troll, either its head or climbing its back. 
func _on_climbable_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.climbing.connect(_on_player_climbing)
		player.stopped_climbing.connect(_on_player_stopped_climbing)

func _on_player_climbing(emitter: Node) -> void:
	if emitter is Player:
		var player: Player = emitter
		player.mounted = true
		has_rider = true
		rider = player

func _on_player_stopped_climbing(emitter: Node) -> void:
	if emitter is Player:
		if rider != null:
			rider.climbing.disconnect(_on_player_climbing)
			rider.stopped_climbing.disconnect(_on_player_stopped_climbing)
			rider.mounted = false
		has_rider = false
		rider = null

func _on_head_detection_box_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.mounted = true
		has_rider = true
		rider = player

func _on_head_detection_box_body_exited(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.mounted = false
		has_rider = false
		rider = null

## Signal connections to handle sorting the player against parts of the troll's sprite.
func _on_troll_front_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		# Don't ever render in front of troll if there are sort locks, as it can result in weird
		# rendering and interactions with the climbable area.
		if player.sort_locks == 0:
			player.z_index = z_index + 1

func _on_troll_front_area_body_exited(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.z_index = player.DEFAULT_SORT_INDEX

func _on_troll_back_area_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		# When the player is in a "render behind troll" zone, count this area as a sort lock.
		player.z_index = player.DEFAULT_SORT_INDEX
		player.sort_locks += 1

func _on_troll_back_area_body_exited(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.sort_locks -= 1
