extends Node

var SPEED

@onready var Server=$".."
@onready var CollisionContainer=$"../CollisionContainer"
@onready var InputManager=$"."
@onready var MapManager=$"../MapManager"
@onready var PlayerManager=$"../PlayerManager"




func _move_player(peer_id:int,direct:int):
	PlayerManager.players_links[peer_id]["Inst"]._move(direct)
	

func _shoot(peer_id:int):
	PlayerManager.players_links[peer_id]["Inst"]._shoot()

func _PU_Use(peer_id):
	PlayerManager.players_links[peer_id]["Inst"]._use_item()

func _build(peer_id):
	PlayerManager.players_links[peer_id]["Inst"].SPEED=0
	PlayerManager.players_links[peer_id]["Phase"]=2
	Server._rquest_target(peer_id, _set_block, true)
var root_cord=-(10*16*5)

func _set_block(x, y, peer_id, meta):
	match meta:
		0:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Brick"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Brick"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 8, Vector2(((x*80)+root_cord),(y*80)+root_cord))
				else:
					if(MapManager.map[str(x)+":"+str(y)]!=null):
						if(MapManager.map[str(x)+":"+str(y)].is_blocking_projectile==false):
								if(MapManager.map[str(x)+":"+str(y)].is_blocking_tank==true):
									MapManager._call_replace(MapManager.map[str(x)+":"+str(y)].name, -1,"")
									PlayerManager.players_links[peer_id]["Blocks"]["Brick"]-=1
			pass
		1:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Concreete"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Concreete"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 4, Vector2(((x*80)+root_cord),(y*80)+root_cord))
				else:
					if(MapManager.map[str(x)+":"+str(y)]!=null):
						if(MapManager.map[str(x)+":"+str(y)].is_blocking_projectile==false):
								if(MapManager.map[str(x)+":"+str(y)].is_blocking_tank==true):
									MapManager._call_replace(MapManager.map[str(x)+":"+str(y)].name, -1,"")
									PlayerManager.players_links[peer_id]["Blocks"]["Concreete"]-=1
			pass
		2:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Bush"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Bush"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 7, Vector2(((x*80)+root_cord),(y*80)+root_cord))
				else:
					if(MapManager.map[str(x)+":"+str(y)]!=null):
						if(MapManager.map[str(x)+":"+str(y)].is_blocking_projectile==false):
								if(MapManager.map[str(x)+":"+str(y)].is_blocking_tank==true):
									MapManager._call_replace(MapManager.map[str(x)+":"+str(y)].name, -1,"")
									PlayerManager.players_links[peer_id]["Blocks"]["Bush"]-=1
			pass
		3:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Water"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Water"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 5, Vector2(((x*80)+root_cord),(y*80)+root_cord))
				else:
					if(MapManager.map[str(x)+":"+str(y)]!=null):
						if(MapManager.map[str(x)+":"+str(y)].is_blocking_projectile==false):
								if(MapManager.map[str(x)+":"+str(y)].is_blocking_tank==true):
									MapManager._call_replace(MapManager.map[str(x)+":"+str(y)].name, -1,"")
									PlayerManager.players_links[peer_id]["Blocks"]["Water"]-=1
			pass
		4:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Field"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Field"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 6, Vector2(((x*80)+root_cord),(y*80)+root_cord))
				else:
					if(MapManager.map[str(x)+":"+str(y)]!=null):
						if(MapManager.map[str(x)+":"+str(y)].is_blocking_projectile==false):
								if(MapManager.map[str(x)+":"+str(y)].is_blocking_tank==true):
									MapManager._call_replace(MapManager.map[str(x)+":"+str(y)].name, -1,"")
									PlayerManager.players_links[peer_id]["Blocks"]["Field"]-=1
			pass
	PlayerManager.players_links[peer_id]["Inst"].SPEED=Server.Constants.tank_speed
	PlayerManager.players_links[peer_id]["Phase"]=0
	Server._update_locals_of_peer(peer_id, {"Blocks":Server.PlayerManager.players_links[peer_id]["Blocks"]})
	pass

