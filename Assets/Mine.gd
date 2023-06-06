extends Area2D

var parent:int
var Server
var flg=true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if (flg):
		if(Server.PlayerManager.players_links.keys().has(parent)):
			if(!(body==Server.PlayerManager.players_links[parent]["Inst"])):
				if(body.is_damageble):
					body.damage(parent)
					Server.MapManager._reliable_spawn(name,17, position)
					get_parent().remove_child(self)
					queue_free()
					flg=false
		else:
			if(body.is_damageble):
					body.damage(-1)
					Server.MapManager._reliable_spawn(name,17, position)
					get_parent().remove_child(self)
					queue_free()
					flg=false
		
	pass # Replace with function body.
