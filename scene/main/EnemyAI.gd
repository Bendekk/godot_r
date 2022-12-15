extends Node2D

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

var _pc: Sprite
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
var _ref_DungeonBoard: DungeonBoard
var _ref_Schedule: Schedule
signal enemy_move(current_sprite,x,y,old_x,old_y)
signal enemy_attack(current_sprite,r)

func _on_Schedule_start_turn(_current_sprite: Sprite) ->void:
	if _current_sprite.is_in_group(_new_GroupName.DWARF) or _current_sprite.is_in_group(_new_GroupName.SKULL) :
		_try_move(_current_sprite)
		_ref_Schedule.end_turn()
	else:
		return

func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite

func _pc_is_close(source: Sprite, target: Sprite) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int
	return delta_x + delta_y < 7

func _pc_is_in_range(source: Sprite, target: Sprite) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int
	return delta_x + delta_y < 2

func _try_move(_current_sprite: Sprite) -> void:
	var target_pos: Array = _new_ConvertCoord.vector_to_array(_current_sprite.position)
	var source_pos: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var moved: bool = false
	var x: int = target_pos[0]
	var y: int = target_pos[1]
	var old_x: int = target_pos[0]
	var old_y: int = target_pos[1]
	if _pc_is_in_range(_pc, _current_sprite):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var r = floor(rng.randf_range(1,21))
		emit_signal("enemy_attack",_current_sprite,r)
	elif _pc_is_close(_pc, _current_sprite):
		if(target_pos[1]-source_pos[1]>=1):
			y-=1
			moved = true
		elif(target_pos[1]-source_pos[1]<=-1):
			y+=1
			moved = true
		elif(target_pos[0]-source_pos[0]>=1):
			x-=1
			moved = true
		elif(target_pos[0]-source_pos[0]<=-1):
			x+=1
			moved = true
		if check_wall(x,y):
			if !check_wall(x,old_y) && old_x != x:
				_current_sprite.position = _new_ConvertCoord.index_to_vector(x, old_y)
				emit_signal("enemy_move",_current_sprite,x,old_y,old_x,old_y)
			elif !check_wall(old_x,y) && old_y != y:
				_current_sprite.position = _new_ConvertCoord.index_to_vector(old_x, y)
				emit_signal("enemy_move",_current_sprite,old_x,y,old_x,old_y)
			else:
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				var r = floor(rng.randf_range(1,4.99))
				if r==1:
					x = old_x+1
					y = old_y
				elif r ==2:
					x= old_x-1
					y=old_y
				elif r==3:
					x=old_x
					y=old_y+1
				elif r==4:
					x=old_x
					y=old_y-1
				while check_wall(x,y):
					x= old_x
					y=old_y
					rng.randomize()
					r = floor(rng.randf_range(1,4.99))
					if r==1:
						x = old_x+1
						y = old_y
					elif r ==2:
						x= old_x-1
						y=old_y
					elif r==3:
						x=old_x
						y=old_y+1
					elif r==4:
						x=old_x
						y=old_y-1
				_current_sprite.position = _new_ConvertCoord.index_to_vector(x, y)
				emit_signal("enemy_move",_current_sprite,x,y,old_x,old_y)	
		else:
			_current_sprite.position = _new_ConvertCoord.index_to_vector(x, y)
			emit_signal("enemy_move",_current_sprite,x,y,old_x,old_y)
	else:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var r = floor(rng.randf_range(1,4.99))
		if r==1:
			x = old_x+1
			y = old_y
		elif r ==2:
			x= old_x-1
			y=old_y
		elif r==3:
			x=old_x
			y=old_y+1
		elif r==4:
			x=old_x
			y=old_y-1
		while check_wall(x,y):
			x= old_x
			y=old_y
			rng.randomize()
			r = floor(rng.randf_range(1,4.99))
			if r==1:
				x = old_x+1
				y = old_y
			elif r ==2:
				x= old_x-1
				y=old_y
			elif r==3:
				x=old_x
				y=old_y+1
			elif r==4:
				x=old_x
				y=old_y-1
		_current_sprite.position = _new_ConvertCoord.index_to_vector(x, y)
		emit_signal("enemy_move",_current_sprite,x,y,old_x,old_y)

func check_wall(x:int, y:int)-> bool:
	if _ref_DungeonBoard.has_sprite(_new_GroupName.WALL,x,y) or _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF,x,y) or _ref_DungeonBoard.has_sprite(_new_GroupName.SKULL,x,y):
		return true
	return false

func _ready():
	pass 
