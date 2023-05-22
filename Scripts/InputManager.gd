extends Node

var SPEED

@onready var Server=$".."
@onready var CollisionContainer=$"../CollisionContainer"
@onready var InputManager=$"."
@onready var MapManager=$"../MapManager"
@onready var PlayerManager=$"../PlayerManager"
var delta_time={}



func _move_player(peer_id:int,dir:int):
	
	SPEED=PlayerManager.players_links[peer_id]["Inst"].SPEED
	var vec:Vector2
	vec.x=0
	vec.y=0
	PlayerManager.players_links[peer_id]["Inst"].dir=dir
	if(!(PlayerManager.players_links[peer_id]["Inst"].SPEED==0)):
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
		delta_time[peer_id]=Time.get_ticks_msec()

func _shoot(id:int):
	if(!(PlayerManager.players_links[id]["Inst"].dead)):
		if (PlayerManager.players_links[id]["Phase"]==0):
			match PlayerManager.players_links[id]["GT"]:
				0:
					if(PlayerManager.players_links[id]["Inst"].supercharge):
						var bul=preload("res://Assets/BunkerBuster.tscn").instantiate()
						bul.position=PlayerManager.players_links[id]["Inst"].position
						bul.dir=PlayerManager.players_links[id]["Inst"].rotation_degrees
						bul.Parent=PlayerManager.players_links[id]["Inst"]
						bul.Server=Server
						bul.name="BB"+str(id)
						CollisionContainer.add_child(bul)
						Server._ini_spawn(29, bul.name, bul.position)
						PlayerManager.players_links[id]["Inst"].supercharge=false
						PlayerManager.players_links[id]["Phase"]=1
						PlayerManager.players_links[id]["Inst"]._reload_based_gun()
					else:
						var bul=preload("res://Assets/Bulet.tscn").instantiate()
						bul.position=PlayerManager.players_links[id]["Inst"].position
						bul.dir=PlayerManager.players_links[id]["Inst"].rotation_degrees
						bul.Parent=PlayerManager.players_links[id]["Inst"]
						bul.Server=Server
						bul.name="bulet"+str(id)+str(Time.get_ticks_msec())
						CollisionContainer.add_child(bul)
						Server._ini_spawn(13, bul.name, bul.position)
						PlayerManager.players_links[id]["Phase"]=1
						PlayerManager.players_links[id]["Inst"]._reload_based_gun()
				1:
					if(PlayerManager.players_links[id]["Inst"].supercharge):
						Server._rquest_target(id, _airStrike)
						PlayerManager.players_links[id]["Inst"].SPEED=0
						PlayerManager.players_links[id]["Inst"].supercharge=false
						PlayerManager.players_links[id]["Phase"]=99
					else:
						var roc=preload("res://Assets/Rocket.tscn").instantiate()
						roc.position=PlayerManager.players_links[id]["Inst"].position
						roc.parent=PlayerManager.players_links[id]["Inst"]
						roc.Server=Server
						roc.name="rocket"+str(id)+str(Time.get_ticks_msec())
						add_child(roc)
						Server._ini_spawn(14, roc.name, roc.position)
						PlayerManager.players_links[id]["Inst"].SPEED=0
						PlayerManager.players_links[id]["Phase"]=1
					pass
				2:
					if(PlayerManager.players_links[id]["Inst"].supercharge):
						Server._rquest_target(id, _OmenStrike)
						PlayerManager.players_links[id]["Inst"].SPEED=0
						PlayerManager.players_links[id]["Inst"].supercharge=false
						PlayerManager.players_links[id]["Phase"]=99
						pass
					else:
						var lb=preload("res://Assets/PlasmaIgnitor.tscn").instantiate()
						var ank=preload("res://Assets/PlasmaAnker.tscn").instantiate()
						PlayerManager.players_links[id]["Inst"].add_child(ank)
						ank.position.y-=10
						lb.anker=ank
						lb.parent=PlayerManager.players_links[id]["Inst"]
						lb.Server=Server
						lb.name="plasma"+str(id)
						PlayerManager.players_links[id]["Inst"].SPEED=Server.Constants.tank_speed/2
						add_child(lb)
						Server._ini_spawn(27, "plasma"+str(id), PlayerManager.players_links[id]["Inst"].position)
						PlayerManager.players_links[id]["Phase"]=2
					pass
				3:
					if(PlayerManager.players_links[id]["Inst"].supercharge):
						var rng = RandomNumberGenerator.new()
						randomize()
						PlayerManager.players_links[id]["Inst"].supercharge=false
						var my_random_number = rng.randf_range(0, Server.PlayerManager.active_players)
						var victum=Server.PlayerManager.players_links[Server.PlayerManager.players_links.keys()[my_random_number]]
						victum["Inst"].damage()
						Server._ini_spawn(30, ("Mafia:"+name),Vector2(0,0))
					else:
						Server._rquest_target(id, _artillary_strike)
						PlayerManager.players_links[id]["Inst"].SPEED=0
						PlayerManager.players_links[id]["Phase"]=1
					pass
		else:
			for i in get_children():
				if(i.name.contains("plasma"+str(id))):
					i._launc()
				if(i.name.contains("rocket"+str(id))):
					i._ignition()

func _PU_Use(peer_id):
	PlayerManager.players_links[peer_id]["Inst"]._use_item()

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


func _OmenStrike(x:int, y:int, striker_id:int):
	PlayerManager.players_links[striker_id]["Inst"].SPEED=Server.Constants.tank_speed
	var OmenRef=preload("res://Assets/OmenStrike.tscn").instantiate()
	OmenRef.Server=Server
	OmenRef._strike(x, y,striker_id)
	add_child(OmenRef)
	PlayerManager.players_links[striker_id]["Phase"]=0
	
func _airStrike(x:int, y:int, striker_id:int):
	PlayerManager.players_links[striker_id]["Phase"]=0
	Server.PlayerManager.players_links[striker_id]["Inst"].SPEED=Server.Constants.tank_speed
	for i in range(0, 22):
		Server.MapManager._hit_cords(x, i)
		Server.MapManager._hit_cords(i, y)
		Server._ini_spawn(17, "AirStrike"+str(striker_id), Vector2(((i*80)+root_cord),(y*80)+root_cord) )
		Server._ini_spawn(17, "AirStrike"+str(striker_id), Vector2(((x*80)+root_cord),(i*80)+root_cord) )
