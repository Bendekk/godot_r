extends Node2D

var _new_DungeonSize := preload("res://library/DungeonSize.gd").new() 
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var tmp_topl
var tmp_botr
var _sprite_dict: Dictionary
signal sprite_removed(remove_sprite, group_name, x, y)
func _ready():
	pass

func is_inside_dungeon(x: int,y:int)->bool:
	return (x<_new_DungeonSize.MAX_X)  and (y<_new_DungeonSize.MAX_Y)

func _on_InitWorld_map_created(topl: Vector2,botr: Vector2) ->void:
	tmp_topl = topl
	tmp_botr = botr
	_sprite_dict.clear()
	var groups = [_new_GroupName.DWARF, _new_GroupName.WALL, _new_GroupName.EXIT, _new_GroupName.POTION, _new_GroupName.SKULL,_new_GroupName.CHEST,_new_GroupName.WEAPON,_new_GroupName.ARMOUR,_new_GroupName.BEER,_new_GroupName.HIPOTION,_new_GroupName.CLOSEDEXIT,_new_GroupName.KEY, _new_GroupName.FLOOR]
	for g in groups:
		_sprite_dict[g] = {}
		for x in range(topl.x,botr.x):
			_sprite_dict[g][x] = []
			_sprite_dict[g][x].resize(abs(topl.y)+abs(botr.y))

#func _init_dict() -> void:
#	_sprite_dict.clear()
##	var groups = [_new_GroupName.DWARF, _new_GroupName.WALL, _new_GroupName.EXIT, _new_GroupName.POTION, _new_GroupName.SKULL,_new_GroupName.CHEST,_new_GroupName.WEAPON,_new_GroupName.ARMOUR,_new_GroupName.BEER,_new_GroupName.HIPOTION,_new_GroupName.CLOSEDEXIT,_new_GroupName.KEY]	
##	for g in groups:
##		_sprite_dict[g] = {}
##		for x in range(-200,_new_DungeonSize.MAX_X):
##			_sprite_dict[g][x] = []
##			_sprite_dict[g][x].resize(_new_DungeonSize.MAX_Y)

func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	var position: Array
	var group_name: String
	if new_sprite.is_in_group(_new_GroupName.DWARF):
		group_name = _new_GroupName.DWARF
	elif new_sprite.is_in_group(_new_GroupName.WALL):
		group_name = _new_GroupName.WALL
	elif new_sprite.is_in_group(_new_GroupName.EXIT):
		group_name = _new_GroupName.EXIT
	elif new_sprite.is_in_group(_new_GroupName.POTION):
		group_name = _new_GroupName.POTION
	elif new_sprite.is_in_group(_new_GroupName.SKULL):
		group_name = _new_GroupName.SKULL
	elif new_sprite.is_in_group(_new_GroupName.CHEST):
		group_name = _new_GroupName.CHEST
	elif new_sprite.is_in_group(_new_GroupName.WEAPON):
		group_name = _new_GroupName.WEAPON
	elif new_sprite.is_in_group(_new_GroupName.ARMOUR):
		group_name = _new_GroupName.ARMOUR
	elif new_sprite.is_in_group(_new_GroupName.BEER):
		group_name = _new_GroupName.BEER
	elif new_sprite.is_in_group(_new_GroupName.HIPOTION):
		group_name = _new_GroupName.HIPOTION
	elif new_sprite.is_in_group(_new_GroupName.CLOSEDEXIT):
		group_name = _new_GroupName.CLOSEDEXIT
	elif new_sprite.is_in_group(_new_GroupName.KEY):
		group_name = _new_GroupName.KEY
	elif new_sprite.is_in_group(_new_GroupName.FLOOR):
		group_name = _new_GroupName.FLOOR
	else:
		return
	position = _new_ConvertCoord.vector_to_array(new_sprite.position)
	_sprite_dict[group_name][position[0]][position[1]] = new_sprite

func get_sprite(group_name: String, x: int, y:int) -> Sprite:
	if not is_inside_dungeon(x,y):
		return null
	return _sprite_dict[group_name][x][y]

func has_sprite(group_name: String, x: int, y: int) -> bool:
	return get_sprite(group_name,x,y) != null

func _on_RemoveObject_sprite_removed(_sprite: Sprite, group_name: String,x: int, y: int) -> void:
	 _sprite_dict[group_name][x][y] = null

func _on_EnemyAI_enemy_move(_current_sprite : Sprite, x: int, y:int,old_x:int,old_y: int) -> void:
	if _current_sprite.is_in_group(_new_GroupName.DWARF):
		_sprite_dict[_new_GroupName.DWARF][old_x][old_y] = null
		_sprite_dict[_new_GroupName.DWARF][x][y] = _current_sprite
	elif _current_sprite.is_in_group(_new_GroupName.SKULL):
		_sprite_dict[_new_GroupName.SKULL][old_x][old_y] = null
		_sprite_dict[_new_GroupName.SKULL][x][y] = _current_sprite

func _on_PCMove_new_dungeon():
	var groups = [_new_GroupName.DWARF, _new_GroupName.WALL, _new_GroupName.EXIT,_new_GroupName.POTION,_new_GroupName.SKULL,_new_GroupName.CHEST,_new_GroupName.WEAPON,_new_GroupName.ARMOUR,_new_GroupName.BEER,_new_GroupName.HIPOTION,_new_GroupName.CLOSEDEXIT,_new_GroupName.KEY, _new_GroupName.FLOOR]
	for g in groups:
		for x in range(tmp_topl.x,tmp_botr.x):
			for y in range(tmp_topl.y,tmp_botr.y):
				var sprite = get_sprite(g,x,y)
				if sprite != null:
					emit_signal("sprite_removed", sprite, g, x, y)
					sprite.queue_free()
