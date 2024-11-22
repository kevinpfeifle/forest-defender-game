class_name HealthComponent
extends Node

@export var max_health: float

signal damaged(amount: float)
signal healed(amount: float)
signal dead()

var alive: bool = true
var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	current_health -= amount
	damaged.emit(amount)
	if current_health < 0:
		alive = false
		dead.emit()

func heal(amount: float) -> void:
	current_health += amount
	healed.emit(amount)