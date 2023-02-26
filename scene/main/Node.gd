extends GutTest

class TestInitWorld:
	extends GutTest
	const Player := preload("res://sprite/PC.tscn")
	var Obj = load('res://scene/main/InitWorld.gd')
	var _obj = null
	func before_each():
		_obj = Obj.new()
	
	func test_pc():
		watch_signals(_obj)
		_obj._create_sprite(Player,"pc",1,1,0,0)
		gut.p('-- passing --')
		assert_eq(get_signal_emit_count(_obj, 'sprite_created'), 1 )
		
	func test_dwarf():
		watch_signals(_obj)
		_obj._init_dwarf()
		gut.p('-- passing --')
		assert_eq(get_signal_emit_count(_obj, 'sprite_created'), 1 )
