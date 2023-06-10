extends CharacterBody2D
var is_damageble:bool=true
var my_master
var dead:bool=false
var Server
var SPEED
var respPos:Vector2=Vector2(0,0)
var dir=0
var is_invincible:bool=false
var supercharge:bool=false
var base:Node=null
var noU:bool=false
var JewMode:bool=false
var x4Mode:bool=false
var hasPoint=false
var Point_inst=null
var last_response


@onready var ReviveTimer=$Revive
# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=Server.Constants.tank_speed
	$Revive.wait_time=Server.Constants.respawn_time
	$BaseReload.wait_time=Server.Constants.bulet_reload

func _add_item(id:int):
	Server.PlayerManager.players_links[my_master]["PU"]=id
	Server._update_locals_of_peer(my_master, {"Powerup":id})

func _asign_base(base_in:Node):
	if(base_in!=null):
		base=base_in
		respPos=base.position

func _use_item():
	match Server.PlayerManager.players_links[my_master]["PU"]:
		18:
			_invincibilate(Server.Constants.invincible_time)
			pass
		19:
			_boost(Server.Constants.speedboost_time, Server.Constants.boost_power)
			pass
		20:
			var new_mine=preload("res://Assets/Mine.tscn").instantiate()
			new_mine.Server=Server
			new_mine.parent=my_master
			new_mine.position=position
			get_parent().add_child(new_mine)
			pass
		21:
			supercharge=true
			pass
		22:
			Server.PlayerManager.players_links[my_master]["GT"]=0
			pass
		23:
			Server.PlayerManager.players_links[my_master]["GT"]=1
			pass
		24:
			Server.PlayerManager.players_links[my_master]["GT"]=2
			pass
		25:
			Server.PlayerManager.players_links[my_master]["GT"]=3
			pass
		31:
			var rng = RandomNumberGenerator.new()
			randomize()
			Server.PlayerManager.players_links[my_master]["Blocks"][Server.PlayerManager.players_links[my_master]["Blocks"].keys()[rng.randi_range(0, 4)]]+=1
			pass
		32:
			var new_spr=preload("res://Assets/sprinkler.tscn").instantiate()
			new_spr.Server=Server
			new_spr.master=my_master
			new_spr.position=Vector2((((position.x-40)/80.0)+11)*80-840,(((position.y-40)/80.0)+11)*80-840 )
			get_parent().add_child(new_spr)
			pass
		33:
			var new_trap=preload("res://Assets/Trap.tscn").instantiate()
			new_trap.Server=Server
			new_trap.parent=my_master
			new_trap.position=position
			get_parent().add_child(new_trap)
			pass
		34:
			Server._rquest_target(my_master, _teleport)
			Server.PlayerManager.players_links[my_master]["Phase"]=10
			pass
		35:
			_camuflage(Server.Constants.camuflage_time)
			pass
		36:
			noU=true
			pass
		37:
			_enable_jet(Server.Constants.jet_time)
			pass
		38:
			JewMode=true
			pass
		39:
			for i in Server.PlayerManager.players_links.keys():
				if(my_master!=i):
					Server.PlayerManager.players_links[i]["Inst"]._boost(Server.Constants.slower_time, Server.Constants.slower_power)
			pass
		40:
			_x4Mode_ini(Server.Constants.x4ModeTime)
			pass
		41:
			var new_rbg=preload("res://Assets/rbg.tscn").instantiate()
			new_rbg.Server=Server
			new_rbg.master=my_master
			get_parent().add_child(new_rbg)
			pass
		42:
			var FF=Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 45, Vector2(0,0))
			FF._asign_target()
			FF.initiator=my_master
			pass
		43:
			for i in range( -1, 2):
				for g in range( -1, 2):
					if(i==0 and g==0):
						pass
					else:
						var tmp_x=((floor((position.x-40)/80.0)+11)+i)
						var tmp_y=((floor((position.y-40)/80.0)+11)+g)
						if(!Server.MapManager.map.has(str(tmp_x)+":"+str(tmp_y))):
							Server.MapManager._reliable_spawn("Fortnite", 8, Vector2(tmp_x*80-800 , tmp_y*80-800))
			pass
			
	Server.PlayerManager.players_links[my_master]["PU"]=-1
	Server._update_locals_of_peer(my_master, {"Powerup":-1, "Blocks":Server.PlayerManager.players_links[my_master]["Blocks"]})

func damage(killer:int):
	if(!is_invincible):
		if(!noU):
			if (Point_inst!=null):
				remove_child(Point_inst)
				get_parent().add_child(Point_inst)
				Point_inst.global_position=global_position
				Server._call_sync(Point_inst.name, Point_inst.global_position, Point_inst.rotation)
				Point_inst.is_picked=false
				Point_inst.fl=true
				Point_inst.holder=null
			Point_inst=null
			dead=true
			ReviveTimer.start()
			Server.MapManager._reliable_spawn(name ,17, position)
			position.y=10000
			Server._call_sync(name, position, rotation)
			Server.PlayerManager.players_links[my_master]["Inst"].SPEED=0
			if(Server.PlayerManager.players_links.has(killer)):
				if(killer!=my_master):
					Server.PlayerManager.players_links[killer]["Score"]+=Server.Constants.kill_score
					
					if (Server.PlayerManager.players_links[killer]["Inst"].JewMode):
						Server.PlayerManager.players_links[killer]["Score"]+=int(Server.PlayerManager.players_links[my_master]["Score"]/2)
						Server.PlayerManager.players_links[my_master]["Score"]-=int(Server.PlayerManager.players_links[my_master]["Score"]/2)
						Server.PlayerManager.players_links[killer]["Inst"].JewMode=false
					Server.PlayerManager._update_scores()
		else:
			if(killer!=-1):
				if(killer!=my_master):
					Server.PlayerManager.players_links[killer]["Inst"].damage(my_master)
			noU=false
	

func _x4Mode_ini(time:float):
	x4Mode=true
	$x4ModeTime.wait_time=time
	$x4ModeTime.start()

func _camuflage(time:float):
	Server._invicibilate_player(my_master)
	$Invicible.wait_time=time
	$Invicible.start()

func _invincibilate(time:float):
	Server._set_states(name, 2)
	is_invincible=true
	$Invincible.wait_time=time
	$Invincible.start()

func _enable_jet(time:float):
	collision_mask=0
	$Jet.wait_time=time
	$Jet.start()
	Server._set_states(name, 4)

func _boost(time:float, power:float):
	SPEED=SPEED*(power)
	$Boost.wait_time=time
	$Boost.start()

func _on_revive_timeout():
	_invincibilate(Server.Constants.spawn_invincible)
	position=respPos
	dead=false
	Server._call_sync(name, position, rotation)
	Server.PlayerManager.players_links[my_master]["Inst"].SPEED=Server.Constants.tank_speed
	hasPoint=false
	pass # Replace with function body.


func _on_invincible_timeout():
	is_invincible=false
	Server._set_states(name, 3)
	pass # Replace with function body.


func _on_boost_timeout():
	SPEED=(Server.Constants.tank_speed)
	pass # Replace with function body.

func _reload_based_gun():
	$BaseReload.start()

func _on_base_reload_timeout():
	Server.PlayerManager.players_links[my_master]["Phase"]=0
	pass # Replace with function body.


@warning_ignore("unused_parameter")
func _teleport(x, y, sender_id, meta=-1):
	var root_cord=-(10*16*5)
	_reload_based_gun()
	if(!Server.MapManager.map.has(str(x)+":"+str(y))):
		position.x=(root_cord+(x*16*5))
		position.y=(root_cord+(y*16*5))
		Server._call_sync(name, position, rotation)


func _on_jet_timeout():
	collision_mask=1
	Server._set_states(name, 5)
	pass # Replace with function body.


func _on_invicible_timeout():
	Server._visibilate_player(my_master)


func _on_x_4_mode_time_timeout():
	x4Mode=false

func _pick_Point(ptr:Node)->bool:
	if(hasPoint):
		return false
	else:
		print("Picked")
		hasPoint=true
		Point_inst=ptr
		return true

func _verify_Point_depos():
	
	if((respPos-position).length()<10):
		
		hasPoint=false
		remove_child(Point_inst)
		get_parent().add_child(Point_inst)
		Point_inst._return()
		if(Server.PlayerManager.players_links.has(Point_inst.master)):
			Server.PlayerManager.players_links[Point_inst.master]["Score"]-=Server.Constants.point_deposit_score
		Point_inst.is_picked=false
		if(Point_inst.master!=-1):
			Server.PlayerManager.players_links[my_master]["Score"]+=Server.Constants.point_deposit_score
		else:
			Server.PlayerManager.players_links[my_master]["Score"]+=Server.Constants.neutral_point_deposit_score
		Server.PlayerManager._update_scores()
		Point_inst=null
	else:
		Server._call_sync(Point_inst.name, Point_inst.global_position, Point_inst.rotation)

func _move(direct:int):
	var vec:Vector2
	vec.x=0
	vec.y=0
	var delta
	if(last_response!=-1):
		delta=float(Time.get_ticks_msec()-last_response)
		delta=delta/13.3
	else:
		delta=0
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
			velocity.x=vec.x*SPEED*delta
			velocity.y=vec.y*SPEED*delta
			Server._set_states(name, 0)
			last_response=Time.get_ticks_msec()
		else:
			velocity.x=0
			velocity.y=0
			Server._set_states(name, 1)
			last_response=-1
		move_and_slide()
		Server._call_sync(name,position, rotation)
		if(hasPoint==true):
			_verify_Point_depos()
			
	else:
		Server._set_states(name, 1)
		last_response=-1
	

func _shoot():
	if(!(dead)):
		if (Server.PlayerManager.players_links[my_master]["Phase"]==0):
			match Server.PlayerManager.players_links[my_master]["GT"]:
				0:
					if(supercharge):
						var bul=Server.MapManager._reliable_spawn(str(my_master), 29,position)
						bul.dir=rotation_degrees
						bul.parent=my_master
						supercharge=false
						Server.PlayerManager.players_links[my_master]["Phase"]=1
						_reload_based_gun()
					else:
						if(x4Mode):
							for i in range (0, 4):
								var bul=Server.MapManager._reliable_spawn(str(my_master)+str(i), 13,position)
								bul.dir=-90+90*i
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
						supercharge=false
						Server.PlayerManager.players_links[my_master]["Phase"]=99
					else:
						if(x4Mode):
							for i in range (0, 4):
								var roc=Server.MapManager._reliable_spawn(str(my_master)+"!"+str(i), 14,Server.PlayerManager.players_links[my_master]["Inst"].position)
								roc.parent=my_master
								roc.my_dir=-90+90*i
							SPEED=0
							Server.PlayerManager.players_links[my_master]["Phase"]=1
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
						supercharge=false
						Server.PlayerManager.players_links[my_master]["Phase"]=99
						pass
					else:
						if(x4Mode):
							var ank=Server.MapManager._reliable_spawn(str(my_master), 27,Vector2(0,0))
							Server.CollisionContainer.remove_child(ank)
							add_child(ank)
							ank.position.y-=10
							
							for i in range (0, 4):
								var lb=preload("res://Assets/PlasmaIgnitor.tscn").instantiate()
								lb.override_dir=true
								lb.overrided=i
								lb.Server=Server
								lb.name="Ignitor!"+str(my_master)
								Server.CollisionContainer.add_child(lb)
								lb.anker=ank
								lb.parent=my_master
							SPEED=Server.Constants.tank_speed/2
							Server.PlayerManager.players_links[my_master]["Phase"]=2
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
					if(supercharge):
						var rng = RandomNumberGenerator.new()
						randomize()
						supercharge=false
						var my_random_number = rng.randf_range(0, Server.PlayerManager.active_players)
						var victum=Server.PlayerManager.players_links[Server.PlayerManager.players_links.keys()[my_random_number]]
						victum["Inst"].damage(my_master)
						Server.MapManager._reliable_spawn("Mafia"+str(my_master) ,30,Vector2(0,0))
					else:
						if(x4Mode):
							Server._rquest_target(my_master, _artillary_strike)
							SPEED=0
							Server.PlayerManager.players_links[my_master]["Phase"]=1
						else:
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
func _artillary_strike(x:int, y:int, striker_id:int, meta=-1):
	var new_strike=preload("res://Assets/ArtillaryShot.tscn").instantiate()
	new_strike.x=x
	new_strike.y=y
	new_strike.Server=Server
	new_strike.striker_id=striker_id
	new_strike._calculate_strike()
	add_child(new_strike)
	Server.PlayerManager.players_links[striker_id]["Inst"].SPEED=Server.Constants.tank_speed
	if(x4Mode):
		SPEED=0
		Server.PlayerManager.players_links[striker_id]["Phase"]=0
		


func _OmenStrike(x:int, y:int, striker_id:int, meta=-1):
	SPEED=Server.Constants.tank_speed
	var OmenRef=preload("res://Assets/OmenStrike.tscn").instantiate()
	OmenRef.Server=Server
	OmenRef._strike(x, y,striker_id)
	add_child(OmenRef)
	Server.PlayerManager.players_links[striker_id]["Phase"]=0
	
func _airStrike(x:int, y:int, striker_id:int, meta=-1):
	Server.PlayerManager.players_links[striker_id]["Phase"]=0
	Server.PlayerManager.players_links[striker_id]["Inst"].SPEED=Server.Constants.tank_speed
	for i in range(0, 22):
		Server.MapManager._hit_cords(x, i, striker_id)
		Server.MapManager._hit_cords(i, y, striker_id)
		Server.MapManager._reliable_spawn( str(striker_id),17, Vector2(((i*80)+root_cord),(y*80)+root_cord) )
		Server.MapManager._reliable_spawn( str(striker_id),17, Vector2(((x*80)+root_cord),(i*80)+root_cord) )
