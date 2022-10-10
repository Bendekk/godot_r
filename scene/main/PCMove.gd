extends Node2D

var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_InputName := preload("res://library/InputName.gd").new()

const Schedule := preload("res://scene/main/Schedule.gd")
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard

var _pc: Sprite

signal pc_moved(message)

const PC_ATTACK: String = "PCAttack"

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	
	if _is_move(event):
		var x: int = source[0]
		var y: int = source[1]
		if event.is_action_pressed(_new_InputName.MOVE_LEFT):
			x -= 1
		elif event.is_action_pressed(_new_InputName.MOVE_RIGHT):
			x += 1
		if event.is_action_pressed(_new_InputName.MOVE_UP):
			y -=1
		if event.is_action_pressed(_new_InputName.MOVE_DOWN):
			y +=1
		_try_move(x,y)

func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)

func _on_Schedule_start_turn(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		set_process_unhandled_input(true)
	#print("{0}: Start turn.".format([current_sprite.name]))

func _is_move(event: InputEvent) -> bool:
	if event.is_action_pressed(_new_InputName.MOVE_LEFT):
		return true
	elif event.is_action_pressed(_new_InputName.MOVE_RIGHT):
		return true
	elif event.is_action_pressed(_new_InputName.MOVE_UP):
		return true
	elif event.is_action_pressed(_new_InputName.MOVE_DOWN):
		return true
	else:
		return false

func _try_move(x:int, y:int)-> void:
	if not _ref_DungeonBoard.is_inside_dungeon(x,y):
		print("Can't leave")
		emit_signal("pc_moved","Can't leave")
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.WALL,x,y):
		print("You hit wall")
		emit_signal("pc_moved","You hit wall")
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF, x, y):
		set_process_unhandled_input(false)
		get_node(PC_ATTACK).attack(_new_GroupName.DWARF, x, y)
	else:
		_pc.position = _new_ConvertCoord.index_to_vector(x, y)
		set_process_unhandled_input(false)
		_ref_Schedule.end_turn()
