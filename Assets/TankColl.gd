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

@onready var ReviveTimer=$Revive
# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=Server.Constants.tank_speed
	$Revive.wait_time=Server.Constants.respawn_time
	$BaseReload.wait_time=Server.Constants.bulet_reload
	pass # Replace with function body.

func _add_item(id:int):
	Server.PlayerManager.players_links[my_master]["PU"]=id
	Server._update_locals_of_peer(my_master, {"Powerup":id})

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
			new_mine.ally=self
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
	Server.PlayerManager.players_links[my_master]["PU"]=-1
	Server._update_locals_of_peer(my_master, {"Powerup":-1})

func damage():
	if(!is_invincible):
		dead=true
		ReviveTimer.start()
		Server.MapManager._reliable_spawn(name ,17, position)
		position.y=10000
		Server._call_sync(name, position, rotation)
		Server.PlayerManager.players_links[my_master]["Inst"].SPEED=0
	

func _invincibilate(time:float):
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
	pass # Replace with function body.


func _on_boost_timeout():
	SPEED=SPEED/(Server.Constants.boost_power)
	pass # Replace with function body.

func _reload_based_gun():
	$BaseReload.start()

func _on_base_reload_timeout():
	Server.PlayerManager.players_links[my_master]["Phase"]=0
	pass # Replace with function body.
