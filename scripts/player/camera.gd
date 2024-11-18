class_name PlayerCamera
extends Camera2D

@export_range(0.0, 1.0) var zoom_speed: float = 0.25
@export_range(1, 10) var max_zoom: int = 2
@export_range(100, 1000) var camera_speed: int = 400

@export var player: Player
var player_last_pos: Vector2

var camera_position: Vector2
var mouse_position: Vector2
var camera_lock: bool = true
var dragging: bool = false

func _ready() -> void:
	player_last_pos = player.position

func _process(delta) -> void:
	# Pan back to player if camera lock is on and player is moving.
	if camera_lock and (player_last_pos != player.position):
		position = player.position
		player_last_pos = player.position

	# Allows camera panning from the keyboard. Needs to be in _process so holding the buttons works.
	if Input.is_action_pressed("camera_move_left"):
		position -= Vector2(camera_speed / zoom.x, 0) * delta
	if Input.is_action_pressed("camera_move_right"):
		position += Vector2(camera_speed / zoom.x, 0) * delta
	if Input.is_action_pressed("camera_move_up"):
		position -= Vector2(0, camera_speed / zoom.y) * delta
	if Input.is_action_pressed("camera_move_down"):
		position += Vector2(0, camera_speed / zoom.y) * delta

## Handles the camera controls: Panning w/ mouse, zoom, camera centering, and camera lock.
func _input(event) -> void:
	if event.is_action("camera_drag"):
		if event.is_pressed():
			dragging = true
			mouse_position = event.position
			camera_position = position
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = ((mouse_position - event.position) / zoom) + camera_position
	elif event.is_action_pressed("camera_zoom_in"):
		var new_zoom: Vector2 = zoom + Vector2(zoom_speed, zoom_speed)
		new_zoom.x = clamp(new_zoom.x, 0.1, max_zoom)
		new_zoom.y = clamp(new_zoom.y, 0.1, max_zoom)
		zoom = new_zoom
	elif event.is_action_pressed("camera_zoom_out"):
		var new_zoom: Vector2 = zoom - Vector2(zoom_speed, zoom_speed)
		new_zoom.x = clamp(new_zoom.x, 0.1, max_zoom)
		new_zoom.y = clamp(new_zoom.y, 0.1, max_zoom)
		zoom = new_zoom
	elif event.is_action_pressed("camera_center"):
		position = player.position
	elif event.is_action_pressed("camera_lock"):
		camera_lock = !camera_lock
