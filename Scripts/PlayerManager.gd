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
			Server._ini_despawn(str(peer_id))
			players_links.erase(peer_id)
			MapManager._asign_base()
			InputManager.delta_time.erase(peer_id)

func _add_player(peer_id:int):
	if(active_players<4):
		var new_tank=preload("res://Assets/TankColl.tscn").instantiate()
		new_tank.name="Player"+str(peer_id)
		new_tank.Server=Server
		new_tank.my_master=peer_id
		CollisionContainer.add_child(new_tank)
		active_players=0
		for i in players_links.keys():
			Server._id_ini_spawn(peer_id,active_players, str(i), players_links[i]["Inst"].position)
			active_players+=1
		for i in CollisionContainer.get_children():
			if(i.name.contains("Block")):
				Server._id_ini_spawn(peer_id, i.type, i.name, i.position)
			if(i.name.contains("Item")):
				Server._id_ini_spawn(peer_id, i.id, i.name, i.position)
		players_links[peer_id]={}
		players_links[peer_id]["Team"]=active_players
		players_links[peer_id]["Inst"]=new_tank
		players_links[peer_id]["GT"]=1
		players_links[peer_id]["PU"]=-1
		players_links[peer_id]["Name"]=""
		players_links[peer_id]["Phase"]=0
		MapManager._asign_base()
		new_tank.position=new_tank.respPos
		Server._ini_spawn( active_players, str(peer_id), new_tank.respPos)
		active_players+=1
		InputManager.delta_time[peer_id]=Time.get_ticks_msec()
		
