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
		Server.MapManager._call_replace(self.name, 0, self.name)
		flg=false
	Server._call_sync(name, position, rotation)
	pass


func _on_body_entered(body):
	if (flg):
		if(Server.PlayerManager.players_links.keys().has(parent)):
			if(!(body==Server.PlayerManager.players_links[parent]["Inst"])):
				if(body.is_damageble):
					body.damage()
				Server.MapManager._call_replace(self.name, 0, self.name)
				Server.MapManager._reliable_spawn(name,26,position)
				flg=false
		else:
			if(body.is_damageble):
				body.damage()
			Server.MapManager._call_replace(self.name, 0, self.name)
			Server.MapManager._reliable_spawn(name,26,position)
			flg=false
	pass # Replace with function body.
