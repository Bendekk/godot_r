extends VBoxContainer

var _new_GroupName := preload("res://library/GroupName.gd").new()

var _turn_counter = 0
var _turn_text = "Turn: {0}"

onready var _label_help: Label = get_node("Help")
onready var _label_turn: Label = get_node("Turn")

func _ready()->void:
	_label_help.text = "Test"
	_update_turn()

func _update_turn() -> void:
	_label_turn.text = _turn_text.format([_turn_counter])

func _on_Schedule_start_turn(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		_turn_counter +=1
		_update_turn()
