extends Label

var _new_GroupName := preload("res://library/GroupName.gd").new()
var text1 = ""
var text2= ""
var text3 = ""
func _ready():
	text = ""
	

func _on_Schedule_end_turn(current_sprite: Sprite) ->void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		text = text3+" \n"+text2+" \n"+text1

func _on_PCMove_pc_moved(message: String)->void:
	text3=text2
	text2=text1
	text1=message
	text = text3+" \n"+text2+" \n"+text1

func _on_PCAttack_pc_attacked(message: String) -> void:
	text3=text2
	text2=text1
	text1=message
	text = text3+" \n"+text2+" \n"+text1
