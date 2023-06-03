extends Area2D
var Server
var fl:bool=true
var id:int
var is_damageble=true
var is_blocking_projectile=false
var is_blocking_tank=false

func damage(killer:int):
	Server.MapManager._call_replace(self.name, 0, self.name)
	
	pass

func _on_body_entered(body):
	if (body.name.contains("Tank")):
		if(fl):
			body._add_item(id)
			Server.MapManager._call_replace(self.name, 0, self.name)
			fl=false
	pass # Replace with function body.
