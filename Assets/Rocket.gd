extends Area2D
var parent:int
var SPEED
var Server
var flg=true
var my_dir
var ignited:bool=false

func _ready():
	SPEED=Server.Constants.rocket_speed

func _process(delta):
	
	if(!ignited):
		if(Server.PlayerManager.players_links.keys().has(parent)):
			my_dir=Server.PlayerManager.players_links[parent]["Inst"].dir
	
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
		if(Server.PlayerManager.players_links.keys().has(parent)):
			Server.PlayerManager.players_links[parent]["Inst"].SPEED=Server.Constants.tank_speed

func _on_body_entered(body):
	if (flg):
		if(Server.PlayerManager.players_links.keys().has(parent)):
			if(!(body==Server.PlayerManager.players_links[parent]["Inst"])):
				if(body.is_damageble):
					body.damage(parent)
				
				Server.MapManager._reliable_spawn(name,26,position)
				var flug=true
				for i in Server.CollisionContainer.get_children():
					if(i.name.contains("Rocket!"+str(parent)) and i!=self):
						flug=false
				if(flug):
					Server.PlayerManager.players_links[parent]["Inst"].SPEED=Server.Constants.tank_speed
					Server.PlayerManager.players_links[parent]["Phase"]=0
				
				flg=false
				Server.MapManager._call_replace(self.name, 0, self.name)
		else:
			if(body.is_damageble):
				body.damage(-1)
			
			Server.MapManager._reliable_spawn(name,26,position)
			flg=false
			Server.MapManager._call_replace(self.name, 0, self.name)
	pass # Replace with function body.
