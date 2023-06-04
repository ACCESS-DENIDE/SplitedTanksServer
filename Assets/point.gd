extends Area2D

var Server
var master:int=-1
var origin:Vector2
var is_picked=false
var is_damageble=false
var is_blocking_projectile=false
var is_blocking_tank=false
var team=-1

var rng=RandomNumberGenerator.new()


func _return():
	if(Server.PlayerManager.players_links.keys().has(master)):
		position=origin
		Server._call_sync(name, position, rotation)
	else:
		Server.MapManager._call_replace(name, 0, "")

func _asign(master_int):
	randomize()
	master=master_int
	origin=Server.PlayerManager.players_links[master_int]["Inst"].respPos
	if(Server.PlayerManager.players_links[master_int]["Inst"].base==null):
		var fap=true
		while(fap):
			var r_x=rng.randi_range(0, 21)
			var r_y=rng.randi_range(0, 21)
			origin=Vector2(r_x*80-800,r_y*80-800)
			if(!Server.MapManager.map.has(str(r_x)+":"+str(r_y))):
				fap=false
	_return()

var fl=true

func _on_body_entered(body):
		if (body.name.contains("Tank")):
			if(body.my_master!=master):
				if(fl):
					if(body._pick_flag(self)):
						
						is_picked=true
						get_parent().remove_child(self)
						body.add_child(self)
						fl=false
			else:
				_return()
