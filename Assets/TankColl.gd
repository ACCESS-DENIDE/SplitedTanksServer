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
var hasFlag=false
var flag_inst=null

@onready var ReviveTimer=$Revive
# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=Server.Constants.tank_speed
	$Revive.wait_time=Server.Constants.respawn_time
	$BaseReload.wait_time=Server.Constants.bulet_reload

func _add_item(id:int):
	Server.PlayerManager.players_links[my_master]["PU"]=id
	Server._update_locals_of_peer(my_master, {"Powerup":id, "Blocks":Server.PlayerManager.players_links[my_master]["Blocks"]})

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
			_enable_jet(Server.Constants.Jet_time)
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
			if (flag_inst!=null):
				remove_child(flag_inst)
				get_parent().add_child(flag_inst)
				flag_inst.global_position=global_position
				Server._call_sync(flag_inst.name, flag_inst.global_position, flag_inst.rotation)
				flag_inst.is_picked=false
				flag_inst.fl=true
				flag_inst.holder=null
			flag_inst=null
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
	hasFlag=false
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
func _teleport(x, y, sender_id):
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

func _pick_flag(ptr:Node)->bool:
	if(hasFlag):
		return false
	else:
		print("Picked")
		hasFlag=true
		flag_inst=ptr
		return true

func _verify_flag_depos():
	
	if((respPos-position).length()<10):
		
		hasFlag=false
		remove_child(flag_inst)
		get_parent().add_child(flag_inst)
		flag_inst._return()
		if(Server.PlayerManager.players_links.has(flag_inst.master)):
			Server.PlayerManager.players_links[flag_inst.master]["Score"]-=Server.Constants.flagDepositScore
		flag_inst.is_picked=false
		if(flag_inst.master!=-1):
			Server.PlayerManager.players_links[my_master]["Score"]+=Server.Constants.flagDepositScore
		else:
			Server.PlayerManager.players_links[my_master]["Score"]+=Server.Constants.NeutralflagDepositScore
		Server.PlayerManager._update_scores()
		flag_inst=null
	else:
		print(flag_inst.position)
		Server._call_sync(flag_inst.name, flag_inst.global_position, flag_inst.rotation)
