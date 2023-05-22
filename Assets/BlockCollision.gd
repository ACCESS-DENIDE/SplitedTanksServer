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

func damage():
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
			print(name)
			Server.MapManager._call_replace(name, 0,"")
			var rng = RandomNumberGenerator.new()
			randomize()
			match rng.randi_range(0,2):
				0:
					randomize()
					match rng.randi_range(0, 3):
						0:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 18, position)
							pass
						1:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 19, position)
							pass
						2:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 20, position)
							pass
						3:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 21, position)
							pass
					pass
				1:
					randomize()
					match rng.randi_range(0, 3):
						0:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 22, position)
							pass
						1:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 23, position)
							pass
						2:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 24, position)
							pass
						3:
							Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 25, position)
							pass
					pass
				2:
					randomize()
					match rng.randi_range(0, 3):
						0:
							pass
						1:
							pass
						2:
							pass
						3:
							pass
					pass
			
			pass

