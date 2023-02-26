extends Node2D

var __
func _ready():
	__ = get_node("InitWorld").connect("sprite_created", get_node("PCMove"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("move_pc", get_node("PCMove"),"_on_InitWorld_move_pc")
	__ = get_node("InitWorld").connect("sprite_created", get_node("Schedule"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("sprite_created", get_node("DungeonBoard"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("sprite_created", get_node("EnemyAI"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("sprite_created", get_node("Camera2D"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("map_created", get_node("Camera2D"),"_on_InitWorld_map_created")
	__ = get_node("InitWorld").connect("map_created", get_node("DungeonBoard"),"_on_InitWorld_map_created")
	__ = get_node("InitWorld").connect("loading_screen", get_node("CanvasLayer/MainGUI/LoadingScreen"),"_on_InitWorld_loading_screen")
	__ = get_node("PCMove").connect("loading_screen", get_node("CanvasLayer/MainGUI/LoadingScreen"),"_on_InitWorld_loading_screen")
	
	__ = get_node("Schedule").connect("start_turn", get_node("EnemyAI"),"_on_Schedule_start_turn")
	__ = get_node("Schedule").connect("start_turn", get_node("PCMove"),"_on_Schedule_start_turn")
	__ = get_node("Schedule").connect("start_turn", get_node("CanvasLayer/MainGUI/SideBarBox"),"_on_Schedule_start_turn")
	__ = get_node("PCMove").connect("hp_change", get_node("CanvasLayer/MainGUI/SideBarBox"),"_on_PCMove_hp_change")
	__ = get_node("PCMove").connect("xp_change", get_node("CanvasLayer/MainGUI/SideBarBox"),"_on_PCMove_xp_change")
	__ = get_node("PCMove").connect("level_up", get_node("CanvasLayer/MainGUI/SideBarBox"),"_on_PCMove_level_up")
	__ = get_node("PCMove").connect("item_found", get_node("CanvasLayer/MainGUI/SideBarBox"),"_on_PCMove_item_found")
	__ = get_node("PCMove").connect("pick_up_key", get_node("CanvasLayer/MainGUI/SideBarBox"),"_on_PCMove_pick_up_key")
	__ = get_node("PCMove").connect("new_dungeon", get_node("InitWorld"),"_on_PCMove_new_dungeon")
	__ = get_node("PCMove").connect("spawn_potion", get_node("InitWorld"),"_on_PCMove_spawn_potion")
	__ = get_node("PCMove").connect("open_exit", get_node("InitWorld"),"_on_PCMove_open_exit")
	__ = get_node("PCMove").connect("drop_chest_item", get_node("InitWorld"),"_on_PCMove_drop_chest_item")
	__ = get_node("PCMove").connect("new_dungeon", get_node("DungeonBoard"),"_on_PCMove_new_dungeon")
	__ = get_node("PCMove").connect("new_dungeon", get_node("Camera2D"),"_on_PCMove_new_dungeon")
	__ = get_node("Schedule").connect("end_turn", get_node("CanvasLayer/MainGUI/Modeline"),"_on_Schedule_end_turn")
	
	__ = get_node("PCMove").connect("pc_moved", get_node("CanvasLayer/MainGUI/Modeline"),"_on_PCMove_pc_moved")
	__ = get_node("PCMove/PCAttack").connect("pc_attacked", get_node("CanvasLayer/MainGUI/Modeline"),"_on_PCAttack_pc_attacked")

	
	__ = get_node("RemoveObject").connect("sprite_removed", get_node("DungeonBoard"),"_on_RemoveObject_sprite_removed")
	__ = get_node("RemoveObject").connect("sprite_removed", get_node("Schedule"),"_on_RemoveObject_sprite_removed")
	__ = get_node("DungeonBoard").connect("sprite_removed", get_node("Schedule"),"_on_RemoveObject_sprite_removed")
	
	__ = get_node("EnemyAI").connect("enemy_move", get_node("DungeonBoard"),"_on_EnemyAI_enemy_move")
	__ = get_node("EnemyAI").connect("enemy_attack", get_node("PCMove"),"_on_EnemyAI_enemy_attack")
	
	get_node("PCMove")._ref_Schedule = get_node("Schedule")
	get_node("EnemyAI")._ref_Schedule = get_node("Schedule")
	get_node("EnemyAI")._ref_DungeonBoard = get_node("DungeonBoard")
	get_node("PCMove")._ref_DungeonBoard = get_node("DungeonBoard")
	get_node("PCMove/PCAttack")._ref_Schedule = get_node("Schedule") 
	get_node("PCMove/PCAttack")._ref_DungeonBoard = get_node("DungeonBoard")
	get_node("PCMove/PCAttack")._ref_RemoveObject = get_node("RemoveObject")
	get_node("PCMove")._ref_RemoveObject = get_node("RemoveObject")
	get_node("RemoveObject")._ref_DungeonBoard = get_node("DungeonBoard")
	get_node("InitWorld").Map = get_node("TileMap")
	get_node("InitWorld")._ref_RemoveObject = get_node("RemoveObject")
	get_node("InitWorld")._ref_DungeonBoard = get_node("DungeonBoard")
