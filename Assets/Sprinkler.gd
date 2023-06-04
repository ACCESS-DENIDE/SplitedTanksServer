extends Node2D
var Server
var master:int
var shoots_remaining:int
# Called when the node enters the scene tree for the first time.
func _ready():
	shoots_remaining=Server.Constants.sprinkler_shoots
	$between.wait_time=Server.Constants.sprinkler_delay
	pass # Replace with function body.




func _on_between_timeout():
	shoots_remaining-=1
	for i in range (0, 4):
		var bul=Server.MapManager._reliable_spawn(str(master), 13,position)
		bul.dir=-90+90*i
		bul.parent=master
	if(shoots_remaining<1):
		get_parent().remove_child(self)
		queue_free()
