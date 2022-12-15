extends Node2D

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")

var _ref_DungeonBoard: DungeonBoard

signal sprite_removed(remove_sprite, group_name, x, y)

func remove(group_name: String, x: int, y: int) -> void:
	var sprite: Sprite = _ref_DungeonBoard.get_sprite(group_name, x, y)
	if sprite != null:
		emit_signal("sprite_removed", sprite, group_name, x, y)
		sprite.queue_free()
	
func _ready():
	pass 

