extends Node2D

var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_InputName := preload("res://library/InputName.gd").new()

const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")

var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard

var _pc: Sprite
var _exit: Sprite
var hp_pc
onready var max_hp = 10
onready var pc_armour=15
onready var pc_attack=0
onready var xp=0
onready var xp_to_lv = 5
onready var f=0
signal pc_moved(message)
signal hp_change(r)
signal xp_change(xp)
signal new_dungeon()
signal game_over()
signal spawn_potion(x,y)
signal level_up(m_hp,xp_m,ar,at)


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
	if new_sprite == null:
		return
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		hp_pc = 10
		set_process_unhandled_input(true)
	elif new_sprite.is_in_group(_new_GroupName.EXIT):
		_exit = new_sprite

func _on_Schedule_start_turn(current_sprite: Sprite) -> void:
	if hp_pc <=0:
		end_game() 
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

func _on_EnemyAI_enemy_attack(_current_sprite : Sprite, r: int):
	if(_current_sprite.is_in_group(_new_GroupName.DWARF)):
		if(r+f-2>pc_armour):
			hp_pc = hp_pc-1
			emit_signal("pc_moved",str("Dwarf hit you ",r+f-2))
			emit_signal("hp_change",hp_pc)
		else:
			emit_signal("pc_moved",str("Dwarf missed you ",r+f-2))
	if(_current_sprite.is_in_group(_new_GroupName.SKULL)):
		if(r+f+2>pc_armour):
			hp_pc = hp_pc-1
			emit_signal("pc_moved",str("Skull hit you ",r+f+2))
			emit_signal("hp_change",hp_pc)
		else:
			emit_signal("pc_moved",str("Skull missed you ",r+f+2))

func _try_move(x:int, y:int)-> void:
	if _ref_DungeonBoard.has_sprite(_new_GroupName.WALL,x,y):
		set_process_unhandled_input(false)
		_ref_Schedule.end_turn()
#		emit_signal("pc_moved","You hit wall")
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.DWARF, x, y):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var r = floor(rng.randf_range(1,21))
		if(r+pc_attack>10+f+2):
			xp+=1
			print(xp,xp_to_lv)
			if(xp>=xp_to_lv):
				xp_to_lv+=1
				xp=0
				var i = rand_range(0.0, 1.0)
				if i<0.25:
					max_hp+=2
					emit_signal("pc_moved",str("Level up +2HP"))
				elif i>=0.25 and i<0.5:
					pc_armour+=1
					emit_signal("pc_moved",str("Level up +1 AC"))
				elif i>=0.5 and i<0.75:
					pc_attack+=1
					emit_signal("pc_moved",str("Level up +1 Attack Power"))
				elif i>=0.75 and i<=1:
					max_hp+=1
					pc_armour+=1
					pc_attack+=1
					emit_signal("pc_moved",str("Level up +1 to all stats"))
				emit_signal("level_up",max_hp,xp_to_lv,pc_armour,pc_attack)
			else:
				emit_signal("xp_change",xp)
			set_process_unhandled_input(false)
			var i = rand_range(0.0, 1.0)
			if i < 0.2:
				emit_signal("spawn_potion",x,y)
			get_node(PC_ATTACK).attack(_new_GroupName.DWARF, x, y,r)
		else:
			emit_signal("pc_moved",str("You missed(",r,")"))
			set_process_unhandled_input(false)
			_ref_Schedule.end_turn()
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.SKULL, x, y):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var r = floor(rng.randf_range(1,21))
		if(r+pc_attack>10+f-2):
			xp+=1
			if(xp>=xp_to_lv):
				xp_to_lv+=1
				xp=0
				var i = rand_range(0.0, 1.0)
				if i<0.25:
					max_hp+=2
					emit_signal("pc_moved",str("Level up +2HP"))
				elif i>=0.25 and i<0.5:
					pc_armour+=1
					emit_signal("pc_moved",str("Level up +1 AC"))
				elif i>=0.5 and i<0.75:
					pc_attack+=1
					emit_signal("pc_moved",str("Level up +1 Attack Power"))
				elif i>=0.75 and i<=1:
					max_hp+=2
					pc_armour+=1
					pc_attack+=1
					emit_signal("pc_moved",str("Level up +1 to all stats"))
				emit_signal("level_up",max_hp,xp_to_lv,pc_armour,pc_attack)
			else:
				emit_signal("xp_change",xp)
			set_process_unhandled_input(false)
			var i = rand_range(0.0, 1.0)
			if i < 0.1:
				emit_signal("spawn_potion",x,y)
			get_node(PC_ATTACK).attack(_new_GroupName.SKULL, x, y,r)
		else:
			emit_signal("pc_moved",str("Miss(",r,")"))
			set_process_unhandled_input(false)
			_ref_Schedule.end_turn()
	else:
		_pc.position = _new_ConvertCoord.index_to_vector(x, y)
		if _pc.position == _exit.position:
			f+=1
			emit_signal("new_dungeon")
		if _ref_DungeonBoard.has_sprite(_new_GroupName.POTION,x,y):
			hp_pc+=2
			if(hp_pc>max_hp):
				hp_pc = max_hp
			emit_signal("hp_change",hp_pc)
			_ref_RemoveObject.remove(_new_GroupName.POTION,x,y)
		set_process_unhandled_input(false)
		_ref_Schedule.end_turn()

func _on_InitWorld_move_pc(x: int, y: int):
	_pc.position = _new_ConvertCoord.index_to_vector(x, y)

func end_game():
	get_tree().change_scene("res://Menu.tscn")
	
func add_hp():
	max_hp+=2
