extends Node

@onready var Server=$".."
@onready var InputManager=$"../InputManager"
@onready var CollisionContainer=$"../CollisionContainer"
@onready var MapManager=$"../MapManager"
@onready var PlayerManager=$"."
@onready var Constants = $"../Constants"
@onready var GMmanager = $"../GameModeManager"

var active_players=0
var players_links={}

func _remoe_player(peer_id:int):
	if( players_links.keys().has(peer_id)):
			GMmanager._removePoint(peer_id)
			_free_team(players_links[peer_id]["Team"])
			active_players-=1
			MapManager.bases.push_back(players_links[peer_id]["Inst"].base)
			players_links[peer_id]["Inst"].damage(-1)
			MapManager._call_replace(players_links[peer_id]["Inst"].name, 0, "")
			players_links.erase(peer_id)
			_update_scores()
			$"../GameModeManager"._point_snitcher()
			#MapManager._asign_base()

var teams=[false, false, false,false]

func _get_free_team()->int:
	for i in range(0, 4):
		if(teams[i]==false):
			teams[i]=true
			return i
	return -1

func _free_team(team:int):
	teams[team]=false

func _add_player(peer_id:int):
	if(active_players<Constants.max_players):
		var pl_team=_get_free_team()
		if (pl_team==-1):
			pl_team=((active_players+1) % 4)
		var new_tank=Server.MapManager._reliable_spawn( str(peer_id),pl_team, Vector2(0,0))
		new_tank.my_master=peer_id
		#new_tank.supercharge=true
		for i in players_links.keys():
			Server._id_ini_spawn(peer_id,players_links[i]["Team"], players_links[i]["Inst"].name, players_links[i]["Inst"].position)
		for i in CollisionContainer.get_children():
			if(i.name.contains("Crate")):
				Server._id_ini_spawn(peer_id, i.type, i.name, i.position)
			if(i.name.contains("Block")):
				Server._id_ini_spawn(peer_id, i.type, i.name, i.position)
			if(i.name.contains("Item")):
				Server._id_ini_spawn(peer_id, i.id, i.name, i.position)
			if(i.name.contains("Poin")):
				Server._id_ini_spawn(peer_id, i.team+46, i.name, i.position)
		players_links[peer_id]={}
		players_links[peer_id]["Team"]=pl_team
		players_links[peer_id]["Inst"]=new_tank
		players_links[peer_id]["GT"]=3
		players_links[peer_id]["PU"]=41
		players_links[peer_id]["Name"]=""
		players_links[peer_id]["Phase"]=0
		players_links[peer_id]["Score"]=0
		players_links[peer_id]["Blocks"]={"Brick"=1, "Concreete"=1, "Bush"=1, "Water"=1, "Field"=1}
		MapManager._asign_base(new_tank)
		new_tank.position=new_tank.respPos
		Server._call_sync(players_links[peer_id]["Inst"].name, players_links[peer_id]["Inst"].position, players_links[peer_id]["Inst"].rotation)
		active_players+=1
		Server._update_locals_of_peer(peer_id, {"Powerup":players_links[peer_id]["PU"], "Blocks":players_links[peer_id]["Blocks"], "Scores":_calc_scores()})
		GMmanager._add_player(peer_id)

func _update_scores():
	for i in players_links.keys():
		Server._update_locals_of_peer(i,{"Scores":_calc_scores()})

func  _calc_scores()->Dictionary:
	var ret={}
	for i in players_links.keys():
		ret[players_links[i]["Name"]]=players_links[i]["Score"]
	return ret
