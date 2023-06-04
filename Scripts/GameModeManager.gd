extends Node
@onready var map_manager = $"../MapManager"
@onready var player_manager = $"../PlayerManager"
@onready var CollisionContainer = $"../CollisionContainer"


var on_end:Callable=_passer
var on_new_Pl:Callable=_passer
var on_pl_remove:Callable=_passer

var round_process=false

func _point_snitcher():
	for i in range(0, player_manager.active_players):
		var new_p=map_manager._reliable_spawn(str((player_manager.players_links.keys()[i])),player_manager.players_links[player_manager.players_links.keys()[i]]["Team"]+46, Vector2(0,0))
		print(new_p.name)
		new_p._asign(player_manager.players_links.keys()[i])
		new_p.team=player_manager.players_links[player_manager.players_links.keys()[i]]["Team"]
	on_new_Pl=_addpoint
	
	pass

func _one_point():
	pass

func _boss_fight():
	pass

func _star_collector():
	pass

func _flag_defence():
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

func _removePoint(peer_id:int):
	print("DebugPoin!"+str(peer_id))
	for i in CollisionContainer.get_children():
		if(i.name.contains("Poin!"+str(peer_id))):
			map_manager._call_replace(i.name, 0, "")
	pass
