extends CharacterBody2D

var is_damageble:bool=true
var my_master
var Server
var SPEED
var dir=0
var supercharge:bool=false
var base:Node=null



var dead:bool=false

var respPos:Vector2=Vector2(0,0)

var is_invincible:bool=false

var noU:bool=false
var JewMode:bool=false
var x4Mode:bool=false
var hasFlag=false
var flag_inst=null

func _ready():
	SPEED=Server.Constants.BossSpeed

func _move(direct:int):
	var vec:Vector2
	vec.x=0
	vec.y=0
	if(direct!=-1):
		dir=direct
	if(!(SPEED==0)):
		match direct:
			0:
				vec.y=-1
				rotation_degrees=0
				pass
			1:
				vec.y=1
				rotation_degrees=180
				pass
			2:
				vec.x=1
				rotation_degrees=90
				pass
			3:
				vec.x=-1
				rotation_degrees=-90
				pass
		if (vec.length()!=0):
			velocity.x=vec.x*SPEED
			velocity.y=vec.y*SPEED
			Server._set_states(name, 0)
		else:
			velocity.x=move_toward(velocity.x, 0, SPEED)
			velocity.y=move_toward(velocity.y, 0, SPEED)
			Server._set_states(name, 1)
		move_and_slide()
		Server._call_sync(name,position, rotation)


func _shoot():
		if (Server.PlayerManager.players_links[my_master]["Phase"]==0):
			match Server.PlayerManager.players_links[my_master]["GT"]:
				0:
					if(supercharge):
						var bul=Server.MapManager._reliable_spawn(str(my_master), 29,position)
						bul.dir=rotation_degrees
						bul.parent=my_master
						Server.PlayerManager.players_links[my_master]["Phase"]=1
						_reload_based_gun()
					else:
							var bul=Server.MapManager._reliable_spawn(str(my_master), 13,position)
							bul.dir=rotation_degrees
							bul.parent=my_master
							Server.PlayerManager.players_links[my_master]["Phase"]=1
							_reload_based_gun()
				1:
					if(supercharge):
						Server._rquest_target(my_master, _airStrike)
						SPEED=0
						Server.PlayerManager.players_links[my_master]["Phase"]=99
					else:
							var roc=Server.MapManager._reliable_spawn(str(my_master), 14,position)
							roc.parent=my_master
							roc.my_dir=dir
							SPEED=0
							Server.PlayerManager.players_links[my_master]["Phase"]=1
					pass
				2:
					if(supercharge):
						Server._rquest_target(my_master, _OmenStrike)
						SPEED=0
						Server.PlayerManager.players_links[my_master]["Phase"]=99
						pass
					else:
							var lb=preload("res://Assets/PlasmaIgnitor.tscn").instantiate()
							lb.Server=Server
							lb.name="Ignitor!"+str(my_master)
							Server.CollisionContainer.add_child(lb)
							var ank=Server.MapManager._reliable_spawn(str(my_master), 27,Vector2(0,0))
							Server.CollisionContainer.remove_child(ank)
							add_child(ank)
							ank.position.y-=10
							lb.anker=ank
							lb.parent=my_master
							SPEED=Server.Constants.tank_speed/2
							Server.PlayerManager.players_links[my_master]["Phase"]=2
					pass
				3:
					Server._rquest_target(my_master, _artillary_strike)
					SPEED=0
					Server.PlayerManager.players_links[my_master]["Phase"]=1
					pass
		else:
			for i in Server.CollisionContainer.get_children():
				if(i.name.contains("Ignitor!"+str(my_master))):
					i._launc()
				if(i.name.contains("Rocket!"+str(my_master))):
					i._ignition()



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
	if(supercharge):
		SPEED=0
		Server.PlayerManager.players_links[striker_id]["Phase"]=0
		

func _add_item(id:int):
	pass

func _use_item():
	print("click")
	supercharge=!supercharge

func damage(killer:int):
	if(Server.PlayerManager.players_links.has(killer)):
		Server.PlayerManager.players_links[killer]["Score"]+=Server.Constants.BossDamageScore
	Server.PlayerManager.players_links[my_master]["Score"]-=Server.Constants.BossDamageScore
	Server.PlayerManager._update_scores()

func _pick_flag(ptr:Node)->bool:
	return false

func _OmenStrike(x:int, y:int, striker_id:int):
	SPEED=Server.Constants.tank_speed
	var OmenRef=preload("res://Assets/OmenStrike.tscn").instantiate()
	OmenRef.Server=Server
	OmenRef._strike(x, y,striker_id)
	add_child(OmenRef)
	Server.PlayerManager.players_links[striker_id]["Phase"]=0
	
func _airStrike(x:int, y:int, striker_id:int):
	Server.PlayerManager.players_links[striker_id]["Phase"]=0
	Server.PlayerManager.players_links[striker_id]["Inst"].SPEED=Server.Constants.tank_speed
	for i in range(0, 22):
		Server.MapManager._hit_cords(x, i, striker_id)
		Server.MapManager._hit_cords(i, y, striker_id)
		Server.MapManager._reliable_spawn( str(striker_id),17, Vector2(((i*80)+root_cord),(y*80)+root_cord) )
		Server.MapManager._reliable_spawn( str(striker_id),17, Vector2(((x*80)+root_cord),(i*80)+root_cord) )

func _reload_based_gun():
	$BaseReload.start()


func _on_base_reload_timeout():
	Server.PlayerManager.players_links[my_master]["Phase"]=0
