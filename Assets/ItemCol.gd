extends Area2D
var Server
var fl:bool=true
var id:int
var is_damageble=true
var is_blocking_projectile=false

func damage():
	get_parent().remove_child(self)
	Server.MapManager._call_replace(self.name, 0, self.name)
	queue_free()
	pass

func _on_body_entered(body):
	if (body.name.contains("Player")):
		if(fl):
			body._add_item(id)
			Server.MapManager._call_replace(self.name, 0, self.name)
			fl=false
	pass # Replace with function body.
