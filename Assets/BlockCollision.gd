extends StaticBody2D

var is_blocking_tank:bool=false
var is_blocking_projectile:bool=false
var is_damageble:bool=false
var Server
var type=0

func _change_type(type_inp:int):
	type=type_inp
	match type_inp:
		4:
			is_blocking_tank=true
			is_blocking_projectile=true
			collision_layer=3
		5:
			is_blocking_tank=true
			is_blocking_projectile=false
			collision_layer=1
		6:
			is_blocking_tank=false
			is_blocking_projectile=true
			collision_layer=2
		7:
			is_blocking_tank=false
			is_blocking_projectile=false
			collision_layer=0
		8:
			is_damageble=true
			is_blocking_tank=true
			is_blocking_projectile=true
			collision_layer=3
		9:
			is_damageble=true
			is_blocking_tank=true
			is_blocking_projectile=true
			collision_layer=3
		10:
			is_damageble=true
			is_blocking_tank=true
			is_blocking_projectile=true
			collision_layer=3
			pass
		11:
			collision_layer=0
			pass
		12:
			is_damageble=true
			is_blocking_tank=true
			is_blocking_projectile=true
			collision_layer=3
			pass

func damage(killer:int):
	match  type:
		8:
			Server.MapManager._call_replace(name, 9,name)
			pass
		9:
			Server.MapManager._call_replace(name, 10,name)
			pass
		10:
			Server.MapManager._call_replace(name, 0,"")
			pass
		12:
			Server.MapManager._call_replace(name, 0,"")
			var rng = RandomNumberGenerator.new()
			randomize()
			match rng.randi_range(0,2):
				0:
					randomize()
					var ri=rng.randi_range(0, 15)
					if(ri<4):
						Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), ri+18, position)
					else:
						Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), ri+28, position)
						
					pass
				1:
					randomize()
					Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), rng.randi_range(0, 3)+22, position)
					pass
				2:
					Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 31, position)
					pass
			
			pass

