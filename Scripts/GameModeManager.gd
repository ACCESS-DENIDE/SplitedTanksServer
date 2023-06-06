extends Node
@onready var map_manager = $"../MapManager"
@onready var player_manager = $"../PlayerManager"
@onready var CollisionContainer = $"../CollisionContainer"
@onready var constants = $"../Constants"
@onready var Server = $".."

var started=false

var on_end:Callable=_passer
var on_new_Pl:Callable=_passer
var on_pl_remove:Callable=_passer

var rng=RandomNumberGenerator.new()

var round_process=false

var Gamemode_objs=[]

func _start_gameplay():
	if(!started):
		started=true
		$BetwenGameMode.start()

func _selectGM():
	
	if(player_manager.active_players==0):
		started=false
		return
	
	randomize()
	match rng.randi_range(0, 5):
		0:
			_point_snitcher()
			pass
		1:
			_one_point()
			pass
		2:
			_boss_fight()
			pass
		3:
			_star_collector()
			pass
		4:
			_flag_defence()
			pass
		5:
			_hohlyonok()
			pass
	
	
	
	pass

func _ready():
	$GameModeEnd.wait_time=constants.round_time_sec
	$BetwenGameMode.wait_time=constants.betwen_round_sec

func _point_snitcher():
	for i in range(0, player_manager.active_players):
		var new_p=map_manager._reliable_spawn(str((player_manager.players_links.keys()[i])),player_manager.players_links[player_manager.players_links.keys()[i]]["Team"]+46, Vector2(0,0))
		print(new_p.name)
		new_p._asign(player_manager.players_links.keys()[i])
		new_p.team=player_manager.players_links[player_manager.players_links.keys()[i]]["Team"]
		Gamemode_objs.push_back(new_p)
	on_new_Pl=_addpoint
	on_pl_remove=_removePoint
	on_end=_PointsEnd
	print("PointsStart")
	$GameModeEnd.start()

func _one_point():
	var new_p=map_manager._reliable_spawn("neutral",50, Vector2(0,0))
	print(new_p.name)
	new_p._asign(-1)
	new_p.team=-1
	Gamemode_objs.push_back(new_p)
	on_new_Pl=_passer
	on_pl_remove=_passer
	on_end=_PointsEnd
	print("OnePointStart")
	$GameModeEnd.start()
	pass

func _boss_fight():
	on_new_Pl=_passer
	on_pl_remove=_passer
	on_end=_removeBoss
	
	randomize()
	var ran=rng.randi_range(0, player_manager.active_players-1)
	var key=player_manager.players_links.keys()[ran]
	var sp_pos=player_manager.players_links[key]["Inst"].position
	Gamemode_objs.push_back(player_manager.players_links[key]["Inst"])
	player_manager.players_links[key]["Inst"].position=Vector2(10000,10000)
	Server._call_sync(player_manager.players_links[key]["Inst"].name,player_manager.players_links[key]["Inst"].position, player_manager.players_links[key]["Inst"].rotation)
	player_manager.players_links[key]["Inst"]=map_manager._reliable_spawn(str(key),56, sp_pos)
	player_manager.players_links[key]["Inst"].my_master=key
	player_manager.players_links[key]["Inst"].Server=$".."
	print("BossStart")
	$GameModeEnd.start()
	
	pass

func _star_collector():
	var st_man=preload("res://Assets/StarManager.tscn").instantiate()
	st_man.Server=$".."
	add_child(st_man)
	Gamemode_objs.push_back(st_man)
	on_new_Pl=_passer
	on_pl_remove=_passer
	on_end=_StarCollectorEnd
	print("StarCollectorStart")
	$GameModeEnd.start()
	pass

func _flag_defence():
	on_new_Pl=_passer
	on_pl_remove=_passer
	on_end=_FlagsEnd
	for i in range(0, player_manager.active_players+2):
		var spawns=map_manager._get_availib_spawns()
		if(spawns.size()>0):
			randomize()
			var cord=spawns[rng.randi_range(0, spawns.size()-1)]
			map_manager._hit_cords(cord.x, cord.y, -1)
			var p=map_manager._reliable_spawn((str(cord.x)+":"+str(cord.y)), 12, Vector2((cord.x*16*5)-800, (cord.y*16*5)-800))
			p.Server=$".."
			Gamemode_objs.push_back(p)
	print("FlagStart")
	$GameModeEnd.start()
	pass

func _hohlyonok():
	on_new_Pl=_passer
	on_pl_remove=_passer
	on_end=_endHohlyonok
	var HH=map_manager._reliable_spawn("Gameplay", 57, Vector2(0,0))
	HH.Server=$".."
	HH.damage(-1)
	Gamemode_objs.push_back(HH)
	print("HohlyonokStart")
	$GameModeEnd.start()
	pass

func _add_player(peer_id:int):
	on_new_Pl.call(peer_id)

func _remove_player(peer_id:int):
	on_pl_remove.call(peer_id)

func _passer(peer_id):
	pass

func _addpoint(peer_id:int):
	var new_p=map_manager._reliable_spawn(str(peer_id),player_manager.players_links[peer_id]["Team"]+46, Vector2(0,0))
	new_p._asign(peer_id)
	Gamemode_objs.push_back(new_p)

func _removePoint(peer_id:int):
	print("DebugPoin!"+str(peer_id))
	for i in CollisionContainer.get_children():
		if(i.name.contains("Poin!"+str(peer_id))):
			map_manager._call_replace(i.name, -1, "")
			Gamemode_objs.erase(i)
	pass

func _PointsEnd():
	for i in Gamemode_objs:
		if(i.holder!=null):
			i.holder.Point_inst=null
			i.holder.hasPoint=false
			i.get_parent().remove_child(i)
			$"../CollisionContainer".add_child(i)
		map_manager._call_replace(i.name, -1, "")

func _removeBoss():
	print("Ended")
	var sp_pos=player_manager.players_links[Gamemode_objs[0].my_master]["Inst"].position
	
	map_manager._call_replace(player_manager.players_links[Gamemode_objs[0].my_master]["Inst"].name, -1, "")
	player_manager.players_links[Gamemode_objs[0].my_master]["Inst"]=Gamemode_objs[0]
	player_manager.players_links[Gamemode_objs[0].my_master]["Inst"].position=sp_pos
	Server._call_sync(player_manager.players_links[Gamemode_objs[0].my_master]["Inst"].name,player_manager.players_links[Gamemode_objs[0].my_master]["Inst"].position, player_manager.players_links[Gamemode_objs[0].my_master]["Inst"].rotation)
	pass

func _StarCollectorEnd():
	remove_child(Gamemode_objs[0])
	Gamemode_objs[0].queue_free()

func _FlagsEnd():
	for i in Gamemode_objs:
		map_manager._call_replace(i.name, -1, "")

func _endHohlyonok():
	map_manager._call_replace(Gamemode_objs[0].name, -1, "")
	pass

func _on_game_mode_end_timeout():
	on_end.call()
	print("GM End")
	$BetwenGameMode.start()
	Gamemode_objs.clear()


func _on_betwen_game_mode_timeout():
	_selectGM()
