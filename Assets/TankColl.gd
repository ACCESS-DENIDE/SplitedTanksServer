extends CharacterBody2D
var is_damageble:bool=true
var my_master
var dead:bool=false
var Server
var Speed=600
var respPos:Vector2=Vector2(0,0)
@onready var ReviveTimer=$Revive
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _add_item(id:int):
	Server.players_links[my_master]["PU"]=id


func damage():
	dead=true
	ReviveTimer.start()
	Server._ini_spawn(17, ("Exp:"+name), position)
	position.y=10000
	Server._call_sync(str(my_master), position, rotation)
	Server.players_links[my_master]["Inst"].Speed=0
	


func _on_revive_timeout():
	position=respPos
	dead=false
	Server._call_sync(str(my_master), position, rotation)
	Server.players_links[my_master]["Inst"].Speed=600
	pass # Replace with function body.
