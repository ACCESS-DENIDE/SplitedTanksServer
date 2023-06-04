extends Node
@onready var map_manager = $"../MapManager"
@onready var player_manager = $"../PlayerManager"
@onready var CollisionContainer = $"../CollisionContainer"
@onready var constants = $"../Constants"


var on_end:Callable=_passer
var on_new_Pl:Callable=_passer
var on_pl_remove:Callable=_passer

var round_process=false

var Gamemode_objs=[]

func _selectGM():
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
	$GameModeEnd.start()
	pass

func _boss_fight():
	pass

func _star_collector():
	pass

func _flag_defence():
	pass

func _hohlyonok():
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
			map_manager._call_replace(i.name, 0, "")
			Gamemode_objs.erase(i)
	pass

func _PointsEnd():
	for i in Gamemode_objs:
		if(i.holder!=null):
			i.holder.flag_inst=null
			i.holder.hasFlag=false
			i.get_parent().remove_child(i)
			$"../CollisionContainer".add_child(i)
		Gamemode_objs.erase(i)
		map_manager._call_replace(i.name, 0, "")


func _on_game_mode_end_timeout():
	on_end.call()
	$BetwenGameMode.start()


func _on_betwen_game_mode_timeout():
	_selectGM()
