extends TextureRect

func _ready():
	pass

func _on_InitWorld_loading_screen():
	if(is_visible()):
		hide()
	else:
		show()
