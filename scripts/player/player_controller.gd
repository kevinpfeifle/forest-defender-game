class_name PlayerController
extends Node2D

@export var character: Character
@export var camera: Camera2D

func _ready():
	# Ensure the camera gets a reference to the character since the loading is inconsitent.
	camera.player = character
