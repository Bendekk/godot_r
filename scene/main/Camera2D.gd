extends Camera2D

var _new_GroupName := preload("res://library/GroupName.gd").new()

var player

func _on_InitWorld_map_created(topl: Vector2,botr: Vector2) ->void:
	limit_top = topl.y * 16
	limit_bottom = botr.y* 16
	limit_left = topl.x*16+1
	limit_right = botr.x*16
	
func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		player = new_sprite
		position.x = player.position.x

func _process(delta):
	if(player!=null):
		position.x=player.position.x
		position.y=player.position.y


