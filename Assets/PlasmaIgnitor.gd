extends Node2D
var Server
var parent:Node
var Ignited:bool=false
var Launched:bool=false
var anker

func _blast():
	var shift_x=floor((parent.position.x-40)/80.0)+11
	var shift_y=floor((parent.position.y-40)/80.0)+11
	var dir=parent.dir
	var len:int=0
	var fl:bool=true
	var rotator=0
	while (fl && (len<21)):
		if(Server.MapManager.map.keys().has(str(shift_x)+":"+str(shift_y))):
			if (Server.MapManager.map[str(shift_x)+":"+str(shift_y)].is_blocking_projectile):
				fl=false
		len+=1
		
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
	if(Server.PlayerManager.players_links.has(parent.my_master)):
		Server.PlayerManager.players_links[parent.my_master]["Inst"]._invincibilate(0.5)
		Server.PlayerManager.players_links[parent.my_master]["Inst"].SPEED=Server.Constants.tank_speed
	for i in range (0, len):
		if(i>0):
			Server.MapManager._hit_cords(shift_x, shift_y)
			Server._ini_spawn(15, ("Beam"+name),Vector2(shift_x*16*5-800, shift_y*16*5-800), rotator)
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
	if(Server.PlayerManager.players_links.has(parent.my_master)):
				Server.PlayerManager.players_links[parent.my_master]["Phase"]=0
	Server.MapManager._call_replace(self.name, 0, self.name)
	if(Server.PlayerManager.players_links.has(parent.my_master)):
		Server.PlayerManager.players_links[parent.my_master]["Inst"].remove_child(anker)
	get_parent().remove_child(self)
	
	pass

func _process(delta):
	Server._call_sync((name), anker.global_position, parent.rotation)

func _on_ignition_timer_timeout():
	Ignited=true
	if(Launched):
		_blast()

func _launc():
	Launched=true
	if(Ignited):
		_blast()
