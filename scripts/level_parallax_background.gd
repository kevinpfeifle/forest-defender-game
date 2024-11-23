class_name LevelParallaxBackground
extends ParallaxBackground

@export var camera: Camera2D

var default_scale_x: float
var default_scale_y: float

func _ready():
	default_scale_x = camera.zoom.x
	default_scale_y = camera.zoom.y

	if default_scale_x < 1:
		scale.x = 1 + (1 - default_scale_x)
	else:
		scale.x = camera.zoom.x
	if default_scale_y < 1:
		scale.y = 1 + (1 - default_scale_y)
	else:
		scale.y = camera.zoom.y

func _process(_delta):
	if camera.zoom.x < 1:
		scale.x = (1 - camera.zoom.x)
	else:
		scale.x = camera.zoom.x
	if camera.zoom.y < 1:
		scale.y = (1 - camera.zoom.y)
	else:
		scale.y = camera.zoom.y