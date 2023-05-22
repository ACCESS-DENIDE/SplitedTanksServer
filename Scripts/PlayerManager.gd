extends Node

@onready var Server=$".."
@onready var InputManager=$"../InputManager"
@onready var CollisionContainer=$"../CollisionContainer"
@onready var MapManager=$"../MapManager"
@onready var PlayerManager=$"."

var active_players=0
var players_links={}

func _remoe_player(peer_id:int):
	if( players_links.keys().has(peer_id)):
			active_players-=1
			CollisionContainer.remove_child(players_links[peer_id]["Inst"])
			players_links[peer_id]["Inst"].queue_free()
			Server._ini_despawn(str(peer_id))
			players_links.erase(peer_id)
			MapManager._asign_base()
			InputManager.delta_time.erase(peer_id)

func _add_player(peer_id:int):
	if(active_players<4):
		var new_tank=Server.MapManager._reliable_spawn( str(peer_id),active_players, Vector2(0,0))
		new_tank.my_master=peer_id
		new_tank.supercharge=true
		active_players=0
		for i in players_links.keys():
			Server._id_ini_spawn(peer_id,active_players, str(i), players_links[i]["Inst"].position)
			active_players+=1
		for i in CollisionContainer.get_children():
			if(i.name.contains("Crate")):
				Server._id_ini_spawn(peer_id, i.type, i.name, i.position)
			if(i.name.contains("Block")):
				Server._id_ini_spawn(peer_id, i.type, i.name, i.position)
			if(i.name.contains("Item")):
				Server._id_ini_spawn(peer_id, i.id, i.name, i.position)
		players_links[peer_id]={}
		players_links[peer_id]["Team"]=active_players
		players_links[peer_id]["Inst"]=new_tank
		match active_players:
			0:
				players_links[peer_id]["GT"]=2
				pass
			1:
				players_links[peer_id]["GT"]=1
				pass
		
		players_links[peer_id]["PU"]=-1
		players_links[peer_id]["Name"]=""
		players_links[peer_id]["Phase"]=0
		#MapManager._asign_base()
		new_tank.position=new_tank.respPos
		active_players+=1
		Server._update_locals_of_peer(peer_id, {"Powerup":players_links[peer_id]["PU"]})
		InputManager.delta_time[peer_id]=Time.get_ticks_msec()
		
