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
			MapManager.bases.push_back(players_links[peer_id]["Inst"].base)
			MapManager._call_replace(players_links[peer_id]["Inst"].name, 0, "")
			players_links.erase(peer_id)
			_update_scores()
			#MapManager._asign_base()


func _add_player(peer_id:int):
	if(active_players<4):
		var new_tank=Server.MapManager._reliable_spawn( str(peer_id),active_players, Vector2(0,0))
		new_tank.my_master=peer_id
		new_tank.supercharge=true
		active_players=0
		for i in players_links.keys():
			Server._id_ini_spawn(peer_id,active_players, players_links[i]["Inst"].name, players_links[i]["Inst"].position)
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
		players_links[peer_id]["GT"]=2
		players_links[peer_id]["PU"]=42
		players_links[peer_id]["Name"]=""
		players_links[peer_id]["Phase"]=0
		players_links[peer_id]["Score"]=0
		players_links[peer_id]["Blocks"]={"Brick"=1, "Concreete"=1, "Bush"=1, "Water"=1, "Field"=1}
		MapManager._asign_base(new_tank)
		new_tank.position=new_tank.respPos
		Server._call_sync(players_links[peer_id]["Inst"].name, players_links[peer_id]["Inst"].position, players_links[peer_id]["Inst"].rotation)
		active_players+=1
		Server._update_locals_of_peer(peer_id, {"Powerup":players_links[peer_id]["PU"], "Blocks":players_links[peer_id]["Blocks"], "Scores":_calc_scores()})
		

func _update_scores():
	for i in players_links.keys():
		Server._update_locals_of_peer(i,{"Scores":_calc_scores()})

func  _calc_scores()->Dictionary:
	var ret={}
	for i in players_links.keys():
		ret[players_links[i]["Name"]]=players_links[i]["Score"]
	return ret
