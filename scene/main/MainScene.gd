extends Node2D

var __

func _ready():
	__ = get_node("InitWorld").connect("sprite_created", get_node("PCMove"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("sprite_created", get_node("Schedule"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("sprite_created", get_node("DungeonBoard"),"_on_InitWorld_sprite_created")
	__ = get_node("InitWorld").connect("sprite_created", get_node("EnemyAI"),"_on_InitWorld_sprite_created")
	
	__ = get_node("Schedule").connect("start_turn", get_node("EnemyAI"),"_on_Schedule_start_turn")
	__ = get_node("Schedule").connect("start_turn", get_node("PCMove"),"_on_Schedule_start_turn")
	__ = get_node("Schedule").connect("start_turn", get_node("MainGUI/SideBarBox"),"_on_Schedule_start_turn")
	
	__ = get_node("Schedule").connect("end_turn", get_node("MainGUI/Modeline"),"_on_Schedule_end_turn")
	
	__ = get_node("PCMove").connect("pc_moved", get_node("MainGUI/Modeline"),"_on_PCMove_pc_moved")
	__ = get_node("PCMove/PCAttack").connect("pc_attacked", get_node("MainGUI/Modeline"),"_on_PCAttack_pc_attacked")
	
	__ = get_node("RemoveObject").connect("sprite_removed", get_node("DungeonBoard"),"_on_RemoveObject_sprite_removed")
	__ = get_node("RemoveObject").connect("sprite_removed", get_node("Schedule"),"_on_RemoveObject_sprite_removed")
	
	__ = get_node("EnemyAI").connect("enemy_move", get_node("DungeonBoard"),"_on_EnemyAI_enemy_move")
	
	get_node("PCMove")._ref_Schedule = get_node("Schedule")
	get_node("EnemyAI")._ref_Schedule = get_node("Schedule")
	get_node("PCMove")._ref_DungeonBoard = get_node("DungeonBoard")
	get_node("PCMove/PCAttack")._ref_Schedule = get_node("Schedule") 
	get_node("PCMove/PCAttack")._ref_DungeonBoard = get_node("DungeonBoard")
	get_node("PCMove/PCAttack")._ref_RemoveObject = get_node("RemoveObject")
	get_node("RemoveObject")._ref_DungeonBoard = get_node("DungeonBoard")
