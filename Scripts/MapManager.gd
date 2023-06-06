extends Node

@onready var Server=$".."
@onready var CollisionContainer=$"../CollisionContainer"
@onready var InputManager=$"../InputManager"
@onready var MapManager=$"."
@onready var PlayerManager=$"../PlayerManager"

var salt=0
var bases=[]
var map={}

func _loadMap(path:String):
	path="res://Maps/CumCramer.json"
	var program=FileAccess.open(path, FileAccess.READ)
	var blocks=JSON.parse_string(program.get_as_text())
	var root_cord=-(10*16*5)
	for i in blocks.keys():
		var x=root_cord+(int(i.split(":")[0])*16*5)
		var y=root_cord+(int(i.split(":")[1])*16*5)
		if(blocks[i]==11):
			bases.push_back(Server.MapManager._reliable_spawn(str(x)+"!"+str(y) ,int(blocks[i]),Vector2(x, y)))
		else:
			Server.MapManager._reliable_spawn(str(x)+"!"+str(y) ,int(blocks[i]),Vector2(x, y))



func _asign_base(player:Node):
	if(bases.size()!=0):
		var rng = RandomNumberGenerator.new()
		randomize()
		var val=rng.randi_range(0, bases.size()-1)
		player._asign_base(bases[val])
		bases.erase(bases[val])

func _unload_map():
	Server._ini_map_unload()
	bases.clear()
	for i in CollisionContainer.get_children():
		if(i.name.contains("Block")):
			CollisionContainer.remove_child(i)
			i.queue_free()
		if(i.name.contains("Item")):
			CollisionContainer.remove_child(i)
			i.queue_free()
		if(i.name.contains("Crate")):
			CollisionContainer.remove_child(i)
			i.queue_free()
	pass

func _hit_cords(x:int, y:int, striker_id:int):
	var root_cord=-(10*16*5)
	if(map.keys().has(str(x)+":"+str(y))):
		if(map[str(x)+":"+str(y)].is_damageble):
			map[str(x)+":"+str(y)].damage(striker_id)
		elif (!(map[str(x)+":"+str(y)].is_blocking_projectile)):
			for i in PlayerManager.players_links.values():
				if(i["Inst"]!=null):
					var size=8*5
					if (i["Inst"].name.contains("Boss")):
						size=size*2
					if((abs((i["Inst"].position.x)-((root_cord+(x*16*5))))<size)&&(abs((i["Inst"].position.y)-((root_cord+(y*16*5))))<size)):
						i["Inst"].damage(striker_id)
	else:
			for i in PlayerManager.players_links.values():
				if(i["Inst"]!=null):
					var size=8*5
					if (i["Inst"].name.contains("Boss")):
						size=size*2
					if((abs((i["Inst"].position.x)-((root_cord+(x*16*5))))<size)&&(abs((i["Inst"].position.y)-((root_cord+(y*16*5))))<size)):
						i["Inst"].damage(striker_id)

func _reliable_spawn(static_name:String,id:int, pos:Vector2, rot:float=0)->Node:
	var new_spawn=null
	var name
	match id:
		0:
			new_spawn=preload("res://Assets/TankColl.tscn").instantiate()	
			name="Tank!"+static_name+"!"+str(salt)
			pass
		1:
			new_spawn=preload("res://Assets/TankColl.tscn").instantiate()
			name="Tank!"+static_name+"!"+str(salt)
			pass
		2:
			new_spawn=preload("res://Assets/TankColl.tscn").instantiate()
			name="Tank!"+static_name+"!"+str(salt)
			pass
		3:
			new_spawn=preload("res://Assets/TankColl.tscn").instantiate()
			name="Tank!"+static_name+"!"+str(salt)
			pass
		4:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		5:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		6:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		7:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		8:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		9:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		10:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		11:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		12:
			new_spawn=preload("res://Assets/BlockCollision.tscn").instantiate()
			name="Block!"+static_name+"!"+str(salt)
			new_spawn._change_type(id)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		13:
			new_spawn=preload("res://Assets/Bulet.tscn").instantiate()
			name="Bulet!"+static_name+"!"+str(salt)
			pass
		14:
			new_spawn=preload("res://Assets/Rocket.tscn").instantiate()
			name="Rocket!"+static_name+"!"+str(salt)
			
			pass
		15:
			name="Laser!"+static_name+"!"+str(salt)
			pass
		16:
			name="Artillary!"+static_name+"!"+str(salt)
			pass
		17:
			name="Explode!"+static_name+"!"+str(salt)
			pass
		18:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		19:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		20:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		21:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		22:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		23:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		24:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		25:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		26:
			name="MiniBoom!"+static_name+"!"+str(salt)
			pass
		27:
			new_spawn=preload("res://Assets/PlasmaAnker.tscn").instantiate()
			name="Anker!"+static_name+"!"+str(salt)
			
			pass
		28:
			
			name="Omen!"+static_name+"!"+str(salt)
			pass
		29:
			new_spawn=preload("res://Assets/BunkerBuster.tscn").instantiate()
			name="BB!"+static_name+"!"+str(salt)
			pass
		30:
			name="Mafia!"+static_name+"!"+str(salt)
			pass
		31:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		32:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		33:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		34:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		35:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		36:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		37:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		38:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		39:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		40:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		41:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		42:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		43:
			new_spawn=preload("res://Assets/ItemCol.tscn").instantiate()
			name="Item!"+static_name+"!"+str(salt)
			new_spawn.id=id
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		45:
			new_spawn=preload("res://Assets/Fazbear.tscn").instantiate()
			name="Fazber!"+static_name+"!"+str(salt)
			pass
		46:
			new_spawn=preload("res://Assets/point.tscn").instantiate()
			name="Poin!"+static_name+"!"+str(salt)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			new_spawn.team=0
			pass
		47:
			new_spawn=preload("res://Assets/point.tscn").instantiate()
			name="Poin!"+static_name+"!"+str(salt)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			new_spawn.team=1
			pass
		48:
			new_spawn=preload("res://Assets/point.tscn").instantiate()
			name="Poin!"+static_name+"!"+str(salt)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			new_spawn.team=2
			pass
		49:
			new_spawn=preload("res://Assets/point.tscn").instantiate()
			name="Poin!"+static_name+"!"+str(salt)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		50:
			new_spawn=preload("res://Assets/point.tscn").instantiate()
			name="Poin!"+static_name+"!"+str(salt)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		55:
			new_spawn=preload("res://Assets/Flag.tscn").instantiate()
			name="Flag!"+static_name+"!"+str(salt)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			pass
		56:
			new_spawn=preload("res://Assets/BossColl.tscn").instantiate()
			name="Boss!"+static_name+"!"+str(salt)
			
			pass
		57:
			new_spawn=preload("res://Assets/BossColl.tscn").instantiate()
			name="Boss!"+static_name+"!"+str(salt)
			
			pass
		58:
			new_spawn=preload("res://Assets/StarCol.tscn").instantiate()
			name="Star!"+static_name+"!"+str(salt)
			map[str(floor((pos.x-40)/80.0)+11)+":"+str(floor((pos.y-40)/80.0)+11)]=new_spawn
			
			pass
	if(new_spawn!=null):
		new_spawn.Server=Server
		new_spawn.name=name
		new_spawn.position=pos
		new_spawn.rotation=rot
		CollisionContainer.add_child(new_spawn)
	Server._ini_spawn(id,name, pos, rot)
	salt+=1
	return new_spawn


func _call_replace(name:String, type:int, new_name:String):
	for i in CollisionContainer.get_children():
		if(i.name==name):
			if(type!=-1):
				i._change_type(type)
			else:
				map.erase(str(floor((i.position.x-40)/(80))+11)+":"+str(floor((i.position.y-40)/(80))+11))
				CollisionContainer.remove_child(i)
				i.queue_free()
	Server._ini_block_change(name, type, new_name)

func _get_availib_spawns()->Array:
	var arr=[]
	for i in range(0, 22):
		for g in range(0, 22):
			if(map.keys().has(str(i)+":"+str(g))):
				pass
			else:
				arr.push_back(Vector2(i, g))
	return arr
