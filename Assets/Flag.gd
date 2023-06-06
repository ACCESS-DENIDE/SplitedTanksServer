extends Area2D

var is_damageble=false
var is_blocking_projectile=false
var is_blocking_tank=false
var internal_obj_list=[]
var capturer
var Server
@onready var CTimer = $CaptureTime

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if (body.name.contains("Tank")):
		internal_obj_list.push_back(body)
		if(internal_obj_list.size()==1):
			CTimer.start()
		else:
			CTimer.stop()

func _on_body_exited(body):
	if (body.name.contains("Tank")):
		internal_obj_list.erase(body)
		if(internal_obj_list.size()==1):
			CTimer.start()
		else:
			CTimer.stop()



func _on_capture_time_timeout():
	capturer=internal_obj_list[0].my_master
	$AddScoreTimer.start()
	Server._ini_block_change(name,Server.PlayerManager.players_links[capturer]["Team"]+51 , name)
	pass # Replace with function body.


func _on_add_score_timer_timeout():
	if(Server.PlayerManager.players_links.has(capturer)):
		Server.PlayerManager.players_links[capturer]["Score"]+=Server.Constants.FlagPerSecScore
		Server.PlayerManager._update_scores()
	pass # Replace with function body.
