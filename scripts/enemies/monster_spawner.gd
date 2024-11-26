class_name MonsterSpawner
extends Node2D

## Monsters will all target the 'Mystic Tree', which if felled will end the game. Monster spawners
## will have a reference set to it from the editor since they will share the same parent node.
## When a monster is instaniated, it will get this reference from the spawner.
@export var active: bool
@export var final_target: MysticTree 
@export var monster_scene: PackedScene

@onready var level = get_parent()

func _ready() -> void:
	var _monster: Monster = spawn_monster()

func spawn_monster() -> Monster:
	if active:
		var monster: Monster = monster_scene.instantiate()
		monster.global_position = global_position
		monster.final_target = final_target
		level.call_deferred("add_child", monster)
		return monster
	else:
		return null
