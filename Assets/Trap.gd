extends Area2D

var parent:int
var Server
var flg=true
var mem
# Called when the node enters the scene tree for the first time.
func _ready():
	$HoldTime.wait_time=Server.Constants.trap_time
	pass # Replace with function body.


func _on_body_entered(body):
	if (flg):
		if(Server.PlayerManager.players_links.keys().has(parent)):
			if(!(body==Server.PlayerManager.players_links[parent]["Inst"])):
				if(body.is_damageble):
					Server.PlayerManager.players_links[body.my_master]["Inst"].SPEED=0
					$HoldTime.start()
					mem=body
		else:
			if(body.is_damageble):
					Server.PlayerManager.players_links[body.my_master]["Inst"].SPEED=0
					$HoldTime.start()
					mem=body
			
	pass # Replace with function body.


func _on_hold_time_timeout():
	mem.SPEED=Server.Constants.tank_speed
	get_parent().remove_child(self)
	queue_free()
	pass # Replace with function body.
