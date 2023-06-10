extends Area2D

var Server
var parent:int
var dir:int=0
var SPEED
var flg:bool=true
var kill_dist=1000000

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=Server.Constants.bulet_speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees=dir
	match dir:
		0:
			position.y-=SPEED*delta
			pass
		90:
			position.x+=SPEED*delta
			pass
		180:
			position.y+=SPEED*delta
			pass
		-180:
			position.y+=SPEED*delta
			pass
		-90:
			position.x-=SPEED*delta
			pass
	if(position.length()>kill_dist):
		
		flg=false
		Server.MapManager._call_replace(self.name, -1, self.name)
	Server._call_sync(name, position, rotation)
	pass


func _on_body_entered(body):
	if (flg):
		if(Server.PlayerManager.players_links.keys().has(parent)):
			if(!(body==Server.PlayerManager.players_links[parent]["Inst"])):
				if(body.is_damageble and !body.name.contains("Block")):
					body.damage(parent)
					Server.MapManager._reliable_spawn(name,26,position)
				else:
					if(body.is_blocking_projectile):
						flg=false
						Server.MapManager._call_replace(body.name, -1, "")
						Server.MapManager._reliable_spawn(name,26,position)
						Server.MapManager._call_replace(self.name, -1, self.name)
		else:
			if(body.is_damageble and !body.name.contains("Block")):
					body.damage(-1)
					Server.MapManager._reliable_spawn(name,26,position)
			else:
				if(body.is_blocking_projectile):
						flg=false
						Server.MapManager(body.name, 0, "")
						Server.MapManager._reliable_spawn(name,26,position)
						Server.MapManager._call_replace(self.name, -1, self.name)
	pass # Replace with function body.

