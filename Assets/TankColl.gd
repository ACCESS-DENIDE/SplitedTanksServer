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
	pass # Replace with function body.

func _add_item(id:int):
	Server.PlayerManager.players_links[my_master]["PU"]=id

func _use_item():
	match Server.PlayerManager.players_links[my_master]["PU"]:
		18:
			_invincibilate(Server.Constants.invincible_time)
			pass
		19:
			_boost(Server.Constants.speedboost_time)
			pass
		20:
			
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

func damage():
	if(!is_invincible):
		dead=true
		ReviveTimer.start()
		Server._ini_spawn(17, ("Exp:"+name), position)
		position.y=10000
		Server._call_sync(str(my_master), position, rotation)
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
	position=respPos
	dead=false
	Server._call_sync(str(my_master), position, rotation)
	Server.PlayerManager.players_links[my_master]["Inst"].SPEED=Server.Constants.tank_speed
	pass # Replace with function body.


func _on_invincible_timeout():
	is_invincible=false
	pass # Replace with function body.


func _on_boost_timeout():
	SPEED=SPEED/(Server.Constants.boost_power)
	pass # Replace with function body.
