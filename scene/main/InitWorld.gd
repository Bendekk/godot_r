extends Node2D

const Player := preload("res://sprite/PC.tscn")
const Dwarf := preload("res://sprite/Dwarf.tscn")
const Wall := preload("res://sprite/Wall.tscn")
const Floor := preload("res://sprite/Floor.tscn")
const ArrowDown := preload("res://sprite/ArrowDown.tscn")
const ArrowRight := preload("res://sprite/ArrowRight.tscn")

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_DungeonSize := preload("res://library/DungeonSize.gd").new() 
var _new_InputName := preload("res://library/InputName.gd").new()

signal sprite_created(new_sprite)

func _unhandled_input(event: InputEvent) ->void:
	if event.is_action_pressed(_new_InputName.INIT_WORLD):
		_init_floor()
		_init_wall()
		_init_dwarf()
		_init_pc()
		set_process_unhandled_input(false)

func _init_dwarf() -> void:
	_create_sprite(Dwarf, _new_GroupName.DWARF,3,3)
	_create_sprite(Dwarf, _new_GroupName.DWARF,18,2)

func _init_pc() -> void:
	_create_sprite(Player,_new_GroupName.PC,_new_DungeonSize.MAX_X/2,_new_DungeonSize.MAX_Y/2)

func _init_floor() -> void:
	for i in range(_new_DungeonSize.MAX_X):
		for j in range (_new_DungeonSize.MAX_Y):
			_create_sprite(Floor,_new_GroupName.FLOOR,i,j)

func _init_wall() -> void:
	_create_sprite(Wall,_new_GroupName.WALL,5,5)
	for i in range(_new_DungeonSize.MAX_X):
		_create_sprite(Wall,_new_GroupName.WALL,i,0)
		_create_sprite(Wall,_new_GroupName.WALL,i,_new_DungeonSize.MAX_Y-1)
	for i in range(_new_DungeonSize.MAX_Y):
		_create_sprite(Wall,_new_GroupName.WALL,0,i)
		_create_sprite(Wall,_new_GroupName.WALL,_new_DungeonSize.MAX_X-1,i)


func _create_sprite(mysprite: PackedScene, group: String, x: int, y: int, x_offset: int =0, y_offset: int=0) ->void:
	var new_sprite: Sprite = mysprite.instance() as Sprite
	new_sprite.position = _new_ConvertCoord.index_to_vector(x,y,x_offset,y_offset)
	new_sprite.add_to_group(group)
	add_child(new_sprite)
	emit_signal("sprite_created", new_sprite)

