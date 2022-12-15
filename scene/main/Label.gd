extends Label


func _ready():
	text = "Click SPACE to start"

func _on_InitWorld_loading_screen()-> void:
	print("halo2222222222")
	if(text==""):
		show()
		text="Click SPACE to start"
	else:
		text=""
		hide()
	
