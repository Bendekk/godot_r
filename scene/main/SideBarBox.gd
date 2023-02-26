extends VBoxContainer

var _new_GroupName := preload("res://library/GroupName.gd").new()

var _turn_counter = 0
var _turn_text = "Turn: {0}"
onready var hp = 10
onready var xp = 0
onready var max_hp = 10
onready var max_xp = 5
onready var _label_hp: Label = get_node("HP_Bar")
onready var _label_turn: Label = get_node("Turn")
onready var _label_xp: Label = get_node("XP")
onready var _label_armour_attack: Label = get_node("Armour_Attack")
onready var _label_key: Label = get_node("Key")

func _ready()->void:
	_label_hp.text = "10/10 HP"
	_label_xp.text = "0/5 XP"
	_label_armour_attack.text = "+0 Attack 15AC"
	_label_key.text = "0/1 Key"
	_update_turn()

func _update_turn() -> void:
	_label_turn.text = _turn_text.format([_turn_counter])

func _on_Schedule_start_turn(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		_turn_counter +=1
		_update_turn()
func _on_PCMove_hp_change(r: int)-> void:
	_label_hp.text = str(r,"/",max_hp," HP")
	hp = r
	
func _on_PCMove_xp_change(r: int):
	_label_xp.text = str(r,"/",max_xp," XP")
	xp = r

func _on_PCMove_level_up(max_h:int,max_x:int,armour:int,attack:int):
	_label_hp.text = str(hp,"/",max_h," HP")
	_label_xp.text = str("0/",max_x," XP")
	_label_armour_attack.text = str("+",attack," Attack ",armour," AC")
	max_hp = max_h
	max_xp = max_x
	
func _on_PCMove_item_found(max_h:int,armour:int,attack:int):
	_label_hp.text = str(hp,"/",max_h," HP")
	_label_armour_attack.text = str("+",attack," Attack ",armour," AC")
	max_hp = max_h

func _on_PCMove_pick_up_key():
	if _label_key.text == "1/1 Key":
		_label_key.text = "0/1 Key"
	else:
		_label_key.text = "1/1 Key"


