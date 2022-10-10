extends Node2D

var _new_GroupName := preload("res://library/GroupName.gd").new()

var _actors: Array = [null]
var _turn: int = 0

signal start_turn(current_sprite)
signal end_turn(Current_sprite)

func _get_current() -> Sprite:
	return _actors[_turn] as Sprite

func _next() -> void:
	_turn += 1
	if _turn > len(_actors)-1:
		_turn = 0

func end_turn() -> void:
	#print("{0}: End turn.".format([_get_current().name]))
	emit_signal("end_turn",_get_current())
	_next()
	emit_signal("start_turn",_get_current())

func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_actors[0] = new_sprite
	elif(new_sprite.is_in_group(_new_GroupName.DWARF)):
		_actors.append(new_sprite)

func _on_RemoveObject_sprite_removed(remove_sprite: Sprite,_group_name: String, _x: int, _y: int) -> void:
	var current_sprite: Sprite = _get_current()
	_actors.erase(remove_sprite)
	_turn = _actors.find(current_sprite)

func _ready():
	pass 

