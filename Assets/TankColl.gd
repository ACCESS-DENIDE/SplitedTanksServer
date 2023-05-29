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
var base:Node
var noU:bool=false
var JewMode:bool=false

@onready var ReviveTimer=$Revive
# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=Server.Constants.tank_speed
	$Revive.wait_time=Server.Constants.respawn_time
	$BaseReload.wait_time=Server.Constants.bulet_reload
	pass # Replace with function body.

func _add_item(id:int):
	Server.PlayerManager.players_links[my_master]["PU"]=id
	Server._update_locals_of_peer(my_master, {"Powerup":id, "Blocks":Server.PlayerManager.players_links[my_master]["Blocks"]})

func _asign_base(base_in:Node):
	base=base_in
	respPos=base.position

func _use_item():
	match Server.PlayerManager.players_links[my_master]["PU"]:
		18:
			_invincibilate(Server.Constants.invincible_time)
			pass
		19:
			_boost(Server.Constants.speedboost_time)
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
			
			pass
		36:
			noU=true
			pass
		37:
			
			pass
		38:
			JewMode=true
			pass
		39:
			
			pass
		40:
			
			pass
		41:
			
			pass
		42:
			var FF=Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 45, Vector2(0,0))
			FF.target=my_master
			pass
		43:
			
			pass
			
	Server.PlayerManager.players_links[my_master]["PU"]=-1
	Server._update_locals_of_peer(my_master, {"Powerup":-1, "Blocks":Server.PlayerManager.players_links[my_master]["Blocks"]})

func damage(killer:int):
	if(!is_invincible):
		if(!noU):
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
	

func _invincibilate(time:float):
	Server._set_states(name, 2)
	is_invincible=true
	$Invincible.wait_time=time
	$Invincible.start()

func _boost(time:float):
	SPEED=SPEED*(Server.Constants.boost_power)
	$Boost.wait_time=time
	$Boost.start()

func _on_revive_timeout():
	_invincibilate(Server.Constants.spawn_invincible)
	position=respPos
	dead=false
	Server._call_sync(name, position, rotation)
	Server.PlayerManager.players_links[my_master]["Inst"].SPEED=Server.Constants.tank_speed
	pass # Replace with function body.


func _on_invincible_timeout():
	is_invincible=false
	Server._set_states(name, 3)
	pass # Replace with function body.


func _on_boost_timeout():
	SPEED=SPEED/(Server.Constants.boost_power)
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
