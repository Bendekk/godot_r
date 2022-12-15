extends Node2D

var _new_DungeonSize := preload("res://library/DungeonSize.gd").new() 
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

var _sprite_dict: Dictionary
signal sprite_removed(remove_sprite, group_name, x, y)
func _ready():
	_init_dict()

func is_inside_dungeon(x: int,y:int)->bool:
	return (x<_new_DungeonSize.MAX_X)  and (y<_new_DungeonSize.MAX_Y)

func _init_dict() -> void:
	_sprite_dict.clear()
	var groups = [_new_GroupName.DWARF, _new_GroupName.WALL, _new_GroupName.EXIT, _new_GroupName.POTION, _new_GroupName.SKULL]	
	for g in groups:
		_sprite_dict[g] = {}
		for x in range(-200,_new_DungeonSize.MAX_X):
			_sprite_dict[g][x] = []
			_sprite_dict[g][x].resize(_new_DungeonSize.MAX_Y)

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
	var groups = [_new_GroupName.DWARF, _new_GroupName.WALL, _new_GroupName.EXIT,_new_GroupName.POTION,_new_GroupName.SKULL]
	for g in groups:
		for x in range(-_new_DungeonSize.MAX_X,_new_DungeonSize.MAX_X):
			for y in range(-_new_DungeonSize.MAX_Y,_new_DungeonSize.MAX_Y):
				var sprite = get_sprite(g,x,y)
				if sprite != null:
					emit_signal("sprite_removed", sprite, g, x, y)
					sprite.queue_free()
	_init_dict()

