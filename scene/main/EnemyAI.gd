extends Node2D

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

var _pc: Sprite

const Schedule := preload("res://scene/main/Schedule.gd")

var _ref_Schedule: Schedule
signal enemy_move(current_sprite,x,y,old_x,old_y)

func _on_Schedule_start_turn(_current_sprite: Sprite) ->void:
	if not _current_sprite.is_in_group(_new_GroupName.DWARF):
		return
	_try_move(_current_sprite)
	_ref_Schedule.end_turn()

func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite

func _pc_is_close(source: Sprite, target: Sprite) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int
	return delta_x + delta_y < 7

func _try_move(_current_sprite: Sprite) -> void:
	var target_pos: Array = _new_ConvertCoord.vector_to_array(_current_sprite.position)
	var source_pos: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var moved: bool = false
	var x: int = target_pos[0]
	var y: int = target_pos[1]
	var old_x: int = target_pos[0]
	var old_y: int = target_pos[1]
	if _pc_is_close(_pc, _current_sprite):
		if(target_pos[1]-source_pos[1]>1):
			y-=1
			moved = true
		elif(target_pos[1]-source_pos[1]<-1):
			y+=1
			moved = true
		if(target_pos[0]-source_pos[0]>1):
			x-=1
			moved = true
		elif(target_pos[0]-source_pos[0]<-1):
			x+=1
			moved = true
	if(target_pos[1]-source_pos[1]==1 && target_pos[0]-source_pos[0]==1 && !moved):
		y-=1
	elif(target_pos[1]-source_pos[1]==-1 && target_pos[0]-source_pos[0]==1 && !moved):
		x-=1
	elif(target_pos[1]-source_pos[1]==1 && target_pos[0]-source_pos[0]==-1 && !moved):
		y-=1
	elif(target_pos[1]-source_pos[1]==-1 && target_pos[0]-source_pos[0]==-1 && !moved):
		y+=1
	_current_sprite.position = _new_ConvertCoord.index_to_vector(x, y)
	emit_signal("enemy_move",_current_sprite,x,y,old_x,old_y)

func _ready():
	pass 
