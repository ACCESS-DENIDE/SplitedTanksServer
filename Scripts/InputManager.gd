extends Node

var SPEED

@onready var Server=$".."
@onready var CollisionContainer=$"../CollisionContainer"
@onready var InputManager=$"."
@onready var MapManager=$"../MapManager"
@onready var PlayerManager=$"../PlayerManager"

func _move_player(peer_id:int,dir:int):
	SPEED=PlayerManager.players_links[peer_id]["Inst"].Speed
	var vec:Vector2
	vec.x=0
	vec.y=0
	if(!(PlayerManager.players_links[peer_id]["Inst"].Speed==0)):
		match dir:
			0:
				vec.y=-1
				PlayerManager.players_links[peer_id]["Inst"].rotation_degrees=0
				pass
			1:
				vec.y=1
				PlayerManager.players_links[peer_id]["Inst"].rotation_degrees=180
				pass
			2:
				vec.x=1
				PlayerManager.players_links[peer_id]["Inst"].rotation_degrees=90
				pass
			3:
				vec.x=-1
				PlayerManager.players_links[peer_id]["Inst"].rotation_degrees=-90
				pass
		if (vec):
			PlayerManager.players_links[peer_id]["Inst"].velocity.x=vec.x*SPEED
			PlayerManager.players_links[peer_id]["Inst"].velocity.y=vec.y*SPEED
		else:
			PlayerManager.players_links[peer_id]["Inst"].velocity.x=move_toward(PlayerManager.players_links[peer_id]["Inst"].velocity.x, 0, SPEED)
			PlayerManager.players_links[peer_id]["Inst"].velocity.y=move_toward(PlayerManager.players_links[peer_id]["Inst"].velocity.y, 0, SPEED)
		PlayerManager.players_links[peer_id]["Inst"].move_and_slide()
		Server._call_sync(str(peer_id), PlayerManager.players_links[peer_id]["Inst"].position, PlayerManager.players_links[peer_id]["Inst"].rotation)

func _shoot(id:int):
	if(!(PlayerManager.players_links[id]["Inst"].dead)):
		if (PlayerManager.players_links[id]["Phase"]==0):
			match PlayerManager.players_links[id]["GT"]:
				0:
					var bul=preload("res://Assets/Bulet.tscn").instantiate()
					bul.position=PlayerManager.players_links[id]["Inst"].position
					bul.dir=PlayerManager.players_links[id]["Inst"].rotation_degrees
					bul.Parent=PlayerManager.players_links[id]["Inst"].name
					bul.Server=PlayerManager
					bul.name=str(id)+str(Time.get_unix_time_from_system())
					CollisionContainer.add_child(bul)
					Server._ini_spawn(13, bul.name, bul.position)
				1:
					pass
				2:
					pass
				3:
					Server._rquest_target(id, _artillary_strike)
					PlayerManager.players_links[id]["Inst"].Speed=0
					PlayerManager.players_links[id]["Phase"]=1
					pass
	pass


var root_cord=-(10*16*5)
var x_cont:int
var y_cont:int
func _artillary_strike(x:int, y:int, striker_id:int):
	var new_strike=preload("res://Assets/ArtillaryShot.tscn").instantiate()
	new_strike.x=x
	new_strike.y=y
	new_strike.Server=Server
	new_strike.striker_id=striker_id
	new_strike._calculate_strike()
	add_child(new_strike)


