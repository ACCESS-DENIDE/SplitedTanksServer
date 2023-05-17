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
			Server.MapManager._call_replace(name, 0,"")
			Server.MapManager._spawn_item(18, position)
			pass

