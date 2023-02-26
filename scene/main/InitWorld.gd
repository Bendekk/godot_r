extends Node2D

const Player := preload("res://sprite/PC.tscn")
const Dwarf := preload("res://sprite/Dwarf.tscn")
const Wall := preload("res://sprite/Wall.tscn")
const Floor := preload("res://sprite/Floor.tscn")
const Potion := preload("res://sprite/Potion.tscn")
const ArrowDown := preload("res://sprite/ArrowDown.tscn")
const ArrowRight := preload("res://sprite/ArrowRight.tscn")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Skull := preload("res://sprite/Skull.tscn")
const Exit := preload("res://sprite/Exit.tscn")
const Chest := preload("res://sprite/Chest.tscn")
const WEAPON := preload("res://sprite/Weapon.tscn")
const ARMOUR := preload("res://sprite/Armour.tscn")
const BEER := preload("res://sprite/Beer.tscn")
const HIPOTION := preload("res://sprite/GoldPotion.tscn")
const ClosedExit := preload("res://sprite/ClosedExit.tscn")
const Key := preload("res://sprite/Key.tscn")
var Room = preload("res://Room.tscn")
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_DungeonSize := preload("res://library/DungeonSize.gd").new() 
var _new_InputName := preload("res://library/InputName.gd").new()
var Map = TileMap
var _ref_RemoveObject: RemoveObject
const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
var _ref_DungeonBoard: DungeonBoard
signal sprite_created(new_sprite)
signal map_created(topl,bottomr)
signal move_pc(x,y)
signal loading_screen()
var path
var start_room = null
var end_room = null
var room_nr
var good_room
var tmp_top
var tmp_bot
var f = 0
func _ready():
	randomize()
	make_rooms()
	
#func _unhandled_input(event: InputEvent) ->void:
#	if event.is_action_pressed(_new_InputName.INIT_WORLD):
##		Map.clear()
##		for room in get_node("../Rooms").get_children():
##			room.queue_free()
##		randomize()
##		make_rooms()
#		_init_pc()
#		_init_dwarf()
#		_init_exit()
#		set_process_unhandled_input(false)
#	if event.is_action_pressed('ui_focus_next'):
##		_init_floor()
##		_init_wall()
##		_init_dwarf()
##		make_map()
##		Map.update_bitmask_region()
#		_init_pc()
#		_init_dwarf()
#		_init_exit()
#		set_process_unhandled_input(false)

func init_all():
		_init_pc()
		_init_dwarf()
		_init_exit()
		_init_skull()
		_init_chest()
		_init_key()
		emit_signal("loading_screen")
		set_process_unhandled_input(false)
		
func _init_dwarf() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(_new_DungeonSize.number_of_enemy1+2*f):
		good_room = 0
		room_nr = floor(rng.randf_range(0,get_node("../Rooms").get_child_count()))
		for room in get_node("../Rooms").get_children():
			if(good_room == room_nr):
				var ul = (room.position / _new_DungeonSize.title_size).floor()
				var s = (room.size /_new_DungeonSize.title_size ).floor()
				s.x = rng.randf_range(-s.x/2,s.x/2)
				s.y = rng.randf_range(-s.y/2,s.y/2)
				_create_sprite(Dwarf, _new_GroupName.DWARF,ul.x+s.x,ul.y+s.y)
			good_room= good_room+1

func _init_skull() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(_new_DungeonSize.number_of_enemy1+2*f):
		good_room = 0
		room_nr = floor(rng.randf_range(0,get_node("../Rooms").get_child_count()))
		for room in get_node("../Rooms").get_children():
			if(good_room == room_nr):
				var ul = (room.position / _new_DungeonSize.title_size).floor()
				var s = (room.size /_new_DungeonSize.title_size ).floor()
				s.x = rng.randf_range(-s.x/2,s.x/2)
				s.y = rng.randf_range(-s.y/2,s.y/2)
				_create_sprite(Skull, _new_GroupName.SKULL,ul.x+s.x,ul.y+s.y)
			good_room= good_room+1
#
func _init_pc() -> void:
	var ul = (start_room.position / _new_DungeonSize.title_size).floor()
	if f == 0:
		_create_sprite(Player,_new_GroupName.PC,ul.x,ul.y)
	else:
		emit_signal("move_pc",ul.x,ul.y)

func _init_exit() -> void:
	var ul = (end_room.position / _new_DungeonSize.title_size).floor()
	_create_sprite(ClosedExit,_new_GroupName.CLOSEDEXIT,ul.x,ul.y)

#func _init_floor() -> void:
#	for i in range(_new_DungeonSize.MAX_X):
#		for j in range (_new_DungeonSize.MAX_Y):
#			_create_sprite(Floor,_new_GroupName.FLOOR,i,j)

func _init_chest() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(f+1):
		good_room = 0
		room_nr = floor(rng.randf_range(0,get_node("../Rooms").get_child_count()))
		for room in get_node("../Rooms").get_children():
			if(good_room == room_nr):
				var ul = (room.position / _new_DungeonSize.title_size).floor()
				var s = (room.size /_new_DungeonSize.title_size ).floor()
				s.x = rng.randf_range(-s.x/2,s.x/2)
				s.y = rng.randf_range(-s.y/2,s.y/2)
				_create_sprite(Chest, _new_GroupName.CHEST,ul.x+s.x,ul.y+s.y)
			good_room+=1

func _init_key() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	good_room = 0
	room_nr = floor(rng.randf_range(0,get_node("../Rooms").get_child_count()))
	for room in get_node("../Rooms").get_children():
			if(good_room == room_nr):
				var ul = (room.position / _new_DungeonSize.title_size).floor()
				var s = (room.size /_new_DungeonSize.title_size ).floor()
				s.x = rng.randf_range(-s.x/2,s.x/2)
				s.y = rng.randf_range(-s.y/2,s.y/2)
				_create_sprite(Key, _new_GroupName.KEY,ul.x+s.x,ul.y+s.y)
			good_room+=1
#
#func _init_wall() -> void:
#	_create_sprite(Wall,_new_GroupName.WALL,5,5)
#	for i in range(_new_DungeonSize.MAX_X):
#		_create_sprite(Wall,_new_GroupName.WALL,i,0)
#		_create_sprite(Wall,_new_GroupName.WALL,i,_new_DungeonSize.MAX_Y-1)
#	for i in range(_new_DungeonSize.MAX_Y):
#		_create_sprite(Wall,_new_GroupName.WALL,0,i)
#		_create_sprite(Wall,_new_GroupName.WALL,_new_DungeonSize.MAX_X-1,i)
#
#
func _create_sprite(mysprite: PackedScene, group: String, x: int, y: int, x_offset: int =0, y_offset: int=0) ->void:
	var new_sprite: Sprite = mysprite.instance() as Sprite
	new_sprite.position = _new_ConvertCoord.index_to_vector(x,y,x_offset,y_offset)
	new_sprite.add_to_group(group)
	add_child(new_sprite)
	emit_signal("sprite_created", new_sprite)

func make_rooms():
	for i in range(_new_DungeonSize.num_room+f):
		var pos = Vector2(0,0)
		var r = Room.instance()
		var w = (_new_DungeonSize.min_size + randi() % (_new_DungeonSize.max_size - _new_DungeonSize.min_size))
		var h = (_new_DungeonSize.min_size + randi() % (_new_DungeonSize.max_size - _new_DungeonSize.min_size))
		r.make_room(pos, Vector2(w,h)*_new_DungeonSize.title_size)
		get_node("../Rooms").add_child(r)
	yield(get_tree().create_timer(0.5), 'timeout')
	var room_positions= []
	var guar_rooms = 0
	for room in get_node("../Rooms").get_children():
		if guar_rooms<7+f:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x,room.position.y,0))
		elif randf() < _new_DungeonSize.cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x,room.position.y,0))
		guar_rooms+=1
	#yield(get_tree(), 'idle_frame')
	yield(get_tree(), 'idle_frame')
	path = find_mst(room_positions)
	yield(get_tree(), 'idle_frame')
	make_map()
	Map.update_bitmask_region()
	init_all()
#func _draw():
#	for room in get_node("../Rooms").get_children():
#		draw_rect(Rect2(room.position - room.size, room.size *2),Color(0,1,0),false)
#	if path:
#		for p in path.get_points():
#			for c in path.get_point_connections(p):
#				var pp = path.get_point_position(p)
#				var cp = path.get_point_position(c)
#				draw_line(Vector2(pp.x,pp.y), Vector2(cp.x,cp.y),Color(1,1,0),15,true)

func _process(delta):
	update()

func find_mst(nodes):
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	while nodes:
		var min_dist = INF
		var min_p = null
		var p = null
		for p1 in path.get_points():
			p1= path.get_point_position(p1)
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		var n = path.get_available_point_id()
		path.add_point(n,min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	return path

func make_map():
	Map.clear()
	find_start_room()
	find_end_room()
	var full = Rect2()
	for room in get_node("../Rooms").get_children():
		var r = Rect2(room.position-room.size,room.get_node("CollisionShape2D").shape.extents*2)
		full = full.merge(r)
	var topl = Map.world_to_map(full.position)
	var bottomr = Map.world_to_map(full.end)
	tmp_top = topl
	tmp_bot = bottomr
	emit_signal("map_created", topl,bottomr)
	for x in range(topl.x, bottomr.x):
		for y in range(topl.y,bottomr.y):
			_create_sprite(Wall,_new_GroupName.WALL,x,y)
			Map.set_cell(x,y,2)
	
	var corridors = []
	for room in get_node("../Rooms").get_children():
		var s = (room.size / _new_DungeonSize.title_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position / _new_DungeonSize.title_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				var sprite: Sprite = _ref_DungeonBoard.get_sprite(_new_GroupName.WALL, ul.x + x, ul.y + y)
				_ref_RemoveObject.remove(_new_GroupName.WALL,ul.x + x,ul.y + y)
				_create_sprite(Floor,_new_GroupName.FLOOR,ul.x + x, ul.y + y)
				Map.set_cell(ul.x + x, ul.y + y,3)
		var p = path.get_closest_point(Vector3(room.position.x,room.position.y,0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x,path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x,path.get_point_position(conn).y))
				carve_path(start,end)
		corridors.append(p)	

func carve_path(p1,p2):
	var x_diff = sign(p2.x - p1.x)
	var y_diff = sign(p2.y - p1.y)
	if x_diff == 0:
		x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0:
		y_diff = pow(-1.0, randi() % 2)
	var x_y = p1
	var y_x = p2
	if (randi()% 2)>0:
		x_y = p2
		y_x = p1
	for x in range(p1.x, p2.x, x_diff):
		Map.set_cell(x, x_y.y ,3)
		Map.set_cell(x, x_y.y + y_diff,3)
		_ref_RemoveObject.remove(_new_GroupName.WALL,x,x_y.y)
		_ref_RemoveObject.remove(_new_GroupName.WALL,x,x_y.y + y_diff)
		if !_ref_DungeonBoard.has_sprite(_new_GroupName.FLOOR,x,x_y.y):
			_create_sprite(Floor,_new_GroupName.FLOOR,x,x_y.y)
		if !_ref_DungeonBoard.has_sprite(_new_GroupName.FLOOR,x,x_y.y + y_diff):
			_create_sprite(Floor,_new_GroupName.FLOOR,x,x_y.y + y_diff)
	for y in range(p1.y, p2.y, y_diff):
		Map.set_cell(y_x.x ,y ,3)
		Map.set_cell(y_x.x + x_diff ,y ,3)
		_ref_RemoveObject.remove(_new_GroupName.WALL,y_x.x ,y)
		_ref_RemoveObject.remove(_new_GroupName.WALL,y_x.x + x_diff ,y)
		if !_ref_DungeonBoard.has_sprite(_new_GroupName.FLOOR,y_x.x ,y):
			_create_sprite(Floor,_new_GroupName.FLOOR,y_x.x ,y)
		if !_ref_DungeonBoard.has_sprite(_new_GroupName.FLOOR,y_x.x + x_diff ,y):
			_create_sprite(Floor,_new_GroupName.FLOOR,y_x.x + x_diff ,y)

func find_start_room():
	var min_x = INF
	for room in get_node("../Rooms").get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in get_node("../Rooms").get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x

func _on_PCMove_new_dungeon():
	f+=1
	Map.clear()
	for room in get_node("../Rooms").get_children():
		room.queue_free()
	randomize()
	make_rooms()
	set_process_unhandled_input(true)

func _on_PCMove_spawn_potion(x,y):
	_create_sprite(Potion,_new_GroupName.POTION,x,y)
   
func _on_PCMove_drop_chest_item(x,y,i):
	if i<0.25:
		_create_sprite(WEAPON,_new_GroupName.WEAPON,x,y)
	elif i>=0.25 and i<0.5:
		_create_sprite(ARMOUR,_new_GroupName.ARMOUR,x,y)
	elif i>=0.5 and i<0.75:
		_create_sprite(BEER,_new_GroupName.BEER,x,y)
	elif i>=0.75 and i<=1:
		_create_sprite(HIPOTION,_new_GroupName.HIPOTION,x,y)

func _on_PCMove_open_exit(x,y):
	_create_sprite(Exit,_new_GroupName.EXIT,x,y)
