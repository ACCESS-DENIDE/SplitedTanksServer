extends Node2D
var Server
var parent:int
var Ignited:bool=false
var Launched:bool=false
var anker
var override_dir:bool=false
var overrided
func _ready():
	$IgnitionTimer.start(Server.Constants.plasma_ignition_time)

func _blast():
	if(Server.PlayerManager.players_links.keys().has(parent)):
		var shift_x=floor((Server.PlayerManager.players_links[parent]["Inst"].position.x-40)/80.0)+11
		var shift_y=floor((Server.PlayerManager.players_links[parent]["Inst"].position.y-40)/80.0)+11
		var dir=Server.PlayerManager.players_links[parent]["Inst"].dir
		var len:int=0
		var fl:bool=true
		var rotator=0
		while (fl && (len<21)):
			if(Server.MapManager.map.keys().has(str(shift_x)+":"+str(shift_y))):
				if (Server.MapManager.map[str(shift_x)+":"+str(shift_y)]!=null):
					if (Server.MapManager.map[str(shift_x)+":"+str(shift_y)].is_blocking_projectile && !Server.MapManager.map[str(shift_x)+":"+str(shift_y)].is_damageble):
						fl=false
			len+=1
			if(override_dir):
				dir=overrided
			match dir:
				0:
					rotator=1.5708
					shift_y-=1
					pass
				1:
					rotator=1.5708
					shift_y+=1
					pass
				2:
					shift_x+=1
					
					pass
				3:
					shift_x-=1
					
					pass
		if(Server.PlayerManager.players_links.has(parent)):
			Server.PlayerManager.players_links[parent]["Inst"]._invincibilate(0.5)
			Server.PlayerManager.players_links[parent]["Inst"].SPEED=Server.Constants.tank_speed
		for i in range (0, len):
			if(i>0):
				Server.MapManager._hit_cords(shift_x, shift_y, parent)
				Server.MapManager._reliable_spawn(name, 15,Vector2(shift_x*16*5-800, shift_y*16*5-800), rotator)
			match dir:
				0:
					
					shift_y+=1
					pass
				1:
					
					shift_y-=1
					pass
				2:
					
					shift_x-=1
					pass
				3:
					
					shift_x+=1
					pass
		if(Server.PlayerManager.players_links.has(parent)):
					Server.PlayerManager.players_links[parent]["Inst"]._reload_based_gun()
					Server.PlayerManager.players_links[parent]["Inst"].remove_child(anker)
					anker.queue_free()
		Server.MapManager._call_replace(self.name, -1, self.name)
		Server.MapManager._call_replace(anker.name, -1, self.name)
	else:
		Server.MapManager._call_replace(self.name, -1, self.name)
		Server.MapManager._call_replace(anker.name, -1, self.name)
	
	
	pass

func _process(delta):
	if(Server.PlayerManager.players_links.has(parent)):
		Server._call_sync((anker.name), anker.global_position, Server.PlayerManager.players_links[parent]["Inst"].rotation)

func _on_ignition_timer_timeout():
	Ignited=true
	if(Launched):
		_blast()

func _launc():
	Launched=true
	if(Ignited):
		_blast()
