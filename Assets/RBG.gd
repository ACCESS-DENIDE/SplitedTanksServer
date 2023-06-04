extends Node

var rng=RandomNumberGenerator.new()

var Server
var master:int
var shoots_remaining:int
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	shoots_remaining=Server.Constants.RBG_shoots
	$between.wait_time=Server.Constants.RBG_delay
	pass # Replace with function body.




func _on_between_timeout():
	shoots_remaining-=1
	for i in range (1, rng.randi_range(Server.Constants.RBGminAmount, Server.Constants.RBGmaxAmount)):
		var r_x=rng.randi_range(0, 21)
		var r_y=rng.randi_range(0, 21)
		Server.MapManager._hit_cords(r_x, r_y, master)
		Server.MapManager._reliable_spawn(name ,17,Vector2(-800+r_x*16*5, -800+r_y*16*5))
	if(shoots_remaining<1):
		get_parent().remove_child(self)
		queue_free()
