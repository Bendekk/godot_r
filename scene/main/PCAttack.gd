extends Node2D
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")

var _ref_DungeonBoard: DungeonBoard
var _ref_Schedule: Schedule
var _ref_RemoveObject: RemoveObject

signal pc_attacked(message)

func _ready():
	pass 

func attack(group_name: String, x: int, y: int) -> void:
	if not _ref_DungeonBoard.has_sprite(group_name, x, y):
		return
	print("Attack.")
	_ref_RemoveObject.remove(group_name,x,y)
	_ref_Schedule.end_turn()
	emit_signal("pc_attacked","You kill Dwarf")
