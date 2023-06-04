extends Node

var SPEED

@onready var Server=$".."
@onready var CollisionContainer=$"../CollisionContainer"
@onready var InputManager=$"."
@onready var MapManager=$"../MapManager"
@onready var PlayerManager=$"../PlayerManager"




func _move_player(peer_id:int,direct:int):
	SPEED=PlayerManager.players_links[peer_id]["Inst"].SPEED
	var vec:Vector2
	vec.x=0
	vec.y=0
	if(direct!=-1):
		PlayerManager.players_links[peer_id]["Inst"].dir=direct
	if(!(PlayerManager.players_links[peer_id]["Inst"].SPEED==0)):
		match direct:
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
		if (vec.length()!=0):
			PlayerManager.players_links[peer_id]["Inst"].velocity.x=vec.x*SPEED
			PlayerManager.players_links[peer_id]["Inst"].velocity.y=vec.y*SPEED
			Server._set_states(PlayerManager.players_links[peer_id]["Inst"].name, 0)
		else:
			PlayerManager.players_links[peer_id]["Inst"].velocity.x=move_toward(PlayerManager.players_links[peer_id]["Inst"].velocity.x, 0, SPEED)
			PlayerManager.players_links[peer_id]["Inst"].velocity.y=move_toward(PlayerManager.players_links[peer_id]["Inst"].velocity.y, 0, SPEED)
			Server._set_states(PlayerManager.players_links[peer_id]["Inst"].name, 1)
		PlayerManager.players_links[peer_id]["Inst"].move_and_slide()
		Server._call_sync(PlayerManager.players_links[peer_id]["Inst"].name, PlayerManager.players_links[peer_id]["Inst"].position, PlayerManager.players_links[peer_id]["Inst"].rotation)

func _shoot(id:int):
	if(!(PlayerManager.players_links[id]["Inst"].dead)):
		if (PlayerManager.players_links[id]["Phase"]==0):
			match PlayerManager.players_links[id]["GT"]:
				0:
					if(PlayerManager.players_links[id]["Inst"].supercharge):
						var bul=Server.MapManager._reliable_spawn(str(id), 29,PlayerManager.players_links[id]["Inst"].position)
						bul.dir=PlayerManager.players_links[id]["Inst"].rotation_degrees
						bul.parent=id
						PlayerManager.players_links[id]["Inst"].supercharge=false
						PlayerManager.players_links[id]["Phase"]=1
						PlayerManager.players_links[id]["Inst"]._reload_based_gun()
					else:
						if(PlayerManager.players_links[id]["Inst"].x4Mode):
							for i in range (0, 4):
								var bul=Server.MapManager._reliable_spawn(str(id)+str(i), 13,PlayerManager.players_links[id]["Inst"].position)
								bul.dir=-90+90*i
								bul.parent=id
							PlayerManager.players_links[id]["Phase"]=1
							PlayerManager.players_links[id]["Inst"]._reload_based_gun()
						else:
							var bul=Server.MapManager._reliable_spawn(str(id), 13,PlayerManager.players_links[id]["Inst"].position)
							bul.dir=PlayerManager.players_links[id]["Inst"].rotation_degrees
							bul.parent=id
							PlayerManager.players_links[id]["Phase"]=1
							PlayerManager.players_links[id]["Inst"]._reload_based_gun()
				1:
					if(PlayerManager.players_links[id]["Inst"].supercharge):
						Server._rquest_target(id, _airStrike)
						PlayerManager.players_links[id]["Inst"].SPEED=0
						PlayerManager.players_links[id]["Inst"].supercharge=false
						PlayerManager.players_links[id]["Phase"]=99
					else:
						if(PlayerManager.players_links[id]["Inst"].x4Mode):
							for i in range (0, 4):
								var roc=Server.MapManager._reliable_spawn(str(id)+"!"+str(i), 14,PlayerManager.players_links[id]["Inst"].position)
								roc.parent=id
								roc.my_dir=-90+90*i
							PlayerManager.players_links[id]["Inst"].SPEED=0
							PlayerManager.players_links[id]["Phase"]=1
						else:
							var roc=Server.MapManager._reliable_spawn(str(id), 14,PlayerManager.players_links[id]["Inst"].position)
							roc.parent=id
							roc.my_dir=PlayerManager.players_links[id]["Inst"].dir
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
						if(PlayerManager.players_links[id]["Inst"].x4Mode):
							var ank=Server.MapManager._reliable_spawn(str(id), 27,Vector2(0,0))
							CollisionContainer.remove_child(ank)
							PlayerManager.players_links[id]["Inst"].add_child(ank)
							ank.position.y-=10
							
							for i in range (0, 4):
								var lb=preload("res://Assets/PlasmaIgnitor.tscn").instantiate()
								lb.override_dir=true
								lb.overrided=i
								lb.Server=Server
								lb.name="Ignitor!"+str(id)
								Server.CollisionContainer.add_child(lb)
								lb.anker=ank
								lb.parent=id
							PlayerManager.players_links[id]["Inst"].SPEED=Server.Constants.tank_speed/2
							PlayerManager.players_links[id]["Phase"]=2
						else:
							var lb=preload("res://Assets/PlasmaIgnitor.tscn").instantiate()
							lb.Server=Server
							lb.name="Ignitor!"+str(id)
							Server.CollisionContainer.add_child(lb)
							var ank=Server.MapManager._reliable_spawn(str(id), 27,Vector2(0,0))
							CollisionContainer.remove_child(ank)
							PlayerManager.players_links[id]["Inst"].add_child(ank)
							ank.position.y-=10
							lb.anker=ank
							lb.parent=id
							PlayerManager.players_links[id]["Inst"].SPEED=Server.Constants.tank_speed/2
							PlayerManager.players_links[id]["Phase"]=2
					pass
				3:
					if(PlayerManager.players_links[id]["Inst"].supercharge):
						var rng = RandomNumberGenerator.new()
						randomize()
						PlayerManager.players_links[id]["Inst"].supercharge=false
						var my_random_number = rng.randf_range(0, Server.PlayerManager.active_players)
						var victum=Server.PlayerManager.players_links[Server.PlayerManager.players_links.keys()[my_random_number]]
						victum["Inst"].damage(id)
						Server.MapManager._reliable_spawn("Mafia"+str(id) ,30,Vector2(0,0))
					else:
						if(PlayerManager.players_links[id]["Inst"].x4Mode):
							Server._rquest_target(id, _artillary_strike)
							PlayerManager.players_links[id]["Inst"].SPEED=0
							PlayerManager.players_links[id]["Phase"]=1
						else:
							Server._rquest_target(id, _artillary_strike)
							PlayerManager.players_links[id]["Inst"].SPEED=0
							PlayerManager.players_links[id]["Phase"]=1
					pass
		else:
			for i in Server.CollisionContainer.get_children():
				if(i.name.contains("Ignitor!"+str(id))):
					i._launc()
				if(i.name.contains("Rocket!"+str(id))):
					i._ignition()

func _PU_Use(peer_id):
	PlayerManager.players_links[peer_id]["Inst"]._use_item()

func _build(peer_id):
	PlayerManager.players_links[peer_id]["Inst"].SPEED=0
	PlayerManager.players_links[peer_id]["Phase"]=2
	Server._rquest_target(peer_id, _set_block, true)


func _set_block(x, y, peer_id, meta):
	match meta:
		0:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Brick"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Brick"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 8, Vector2(((x*80)+root_cord),(y*80)+root_cord))
			pass
		1:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Concreete"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Concreete"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 4, Vector2(((x*80)+root_cord),(y*80)+root_cord))
			pass
		2:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Bush"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Bush"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 7, Vector2(((x*80)+root_cord),(y*80)+root_cord))
			pass
		3:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Water"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Water"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 5, Vector2(((x*80)+root_cord),(y*80)+root_cord))
			pass
		4:
			if (PlayerManager.players_links[peer_id]["Blocks"]["Field"]>0):
				if(!MapManager.map.keys().has(str(x)+":"+str(y))):
					PlayerManager.players_links[peer_id]["Blocks"]["Field"]-=1
					MapManager._reliable_spawn(str(x)+"!"+str(y), 6, Vector2(((x*80)+root_cord),(y*80)+root_cord))
			pass
	PlayerManager.players_links[peer_id]["Inst"].SPEED=Server.Constants.tank_speed
	PlayerManager.players_links[peer_id]["Phase"]=0
	Server._update_locals_of_peer(peer_id, {"Powerup":Server.PlayerManager.players_links[peer_id]["PU"], "Blocks":Server.PlayerManager.players_links[peer_id]["Blocks"]})
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
	Server.PlayerManager.players_links[striker_id]["Inst"].SPEED=Server.Constants.tank_speed
	if(PlayerManager.players_links[striker_id]["Inst"].x4Mode):
		PlayerManager.players_links[striker_id]["Inst"].SPEED=0
		PlayerManager.players_links[striker_id]["Phase"]=0
		


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
		Server.MapManager._hit_cords(x, i, striker_id)
		Server.MapManager._hit_cords(i, y, striker_id)
		Server.MapManager._reliable_spawn( str(striker_id),17, Vector2(((i*80)+root_cord),(y*80)+root_cord) )
		Server.MapManager._reliable_spawn( str(striker_id),17, Vector2(((x*80)+root_cord),(i*80)+root_cord) )
