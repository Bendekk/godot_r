extends GutTest

class TestInit:
	extends GutTest
	const Player := preload("res://sprite/PC.tscn")
	var Obj = load('res://scene/main/InitWorld.gd')
	var _obj = null

	func before_each():
		_obj = Obj.new()

	func test_sprite_create():
		watch_signals(_obj)
		_obj._create_sprite(Player, "pc",1,1)
		gut.p('-- passing --')
		assert_signal_emitted(_obj,"sprite_created")
	
class TestConvertCoord:
	extends GutTest
	var Obj = load('res://library/ConvertCoord.gd')
	var _obj = null

	func before_each():
		_obj = Obj.new()
	
	func test_vector_to_array():
		assert_eq(_obj.vector_to_array(Vector2(12,60)),[0,3]) #(12-6)16=0,(60-8)/16=3
	
	func test_index_to_vector():
		assert_eq(_obj.index_to_vector(1,5),Vector2(24,88)) #8+1*16=24, 8+5+16=88

class TestDungeonBoard:
	extends GutTest
	const Key := preload("res://sprite/Key.tscn")
	var Obj = load('res://scene/main/DungeonBoard.gd')
	var _obj = null

	func before_each():
		_obj = Obj.new()
	
	func test_dictionary():
		_obj._on_InitWorld_map_created(Vector2(-1,-1),Vector2(1,1))
		var new_sprite: Sprite = Key.instance() as Sprite
		new_sprite.position = Vector2(0,0)
		new_sprite.add_to_group("key")
		_obj._on_InitWorld_sprite_created(new_sprite)
		print(_obj._sprite_dict)
		assert_eq(_obj.get_sprite("key",-0,0),new_sprite)

	

