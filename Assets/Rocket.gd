extends Area2D
var parent:Node
var SPEED
var Server
var flg=true
var my_dir
var ignited:bool=false

func _ready():
	SPEED=Server.Constants.rocket_speed

func _process(delta):
	
	if(!ignited):
		my_dir=parent.dir
	
	match my_dir:
		0:
			position.y-=SPEED*delta
			rotation_degrees=0
			pass
		1:
			position.y+=SPEED*delta
			rotation_degrees=180
			pass
		2:
			position.x+=SPEED*delta
			rotation_degrees=90
			pass
		3:
			position.x-=SPEED*delta
			rotation_degrees=-90
			pass
	Server._call_sync(name, position, rotation)
	pass

func _ignition():
	if(!ignited):
		SPEED=SPEED*2
		ignited=true
		parent.SPEED=Server.Constants.tank_speed

func _on_body_entered(body):
	if (flg):
		if(!(body==parent)):
			if(body.is_damageble):
				body.damage()
			Server.MapManager._call_replace(self.name, 0, self.name)
			parent.SPEED=Server.Constants.tank_speed
			Server.MapManager._reliable_spawn(name,26,position)
			if(Server.PlayerManager.players_links.has(parent.my_master)):
				Server.PlayerManager.players_links[parent.my_master]["Phase"]=0
			flg=false
	pass # Replace with function body.
