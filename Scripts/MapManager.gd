extends Node

@onready var Server=$".."
@onready var CollisionContainer=$"../CollisionContainer"
@onready var InputManager=$"../InputManager"
@onready var MapManager=$"."
@onready var PlayerManager=$"../PlayerManager"

var bases={}
var map={}

func _loadMap(path:String):
	path="res://Maps/CumCramer.json"
	var program=FileAccess.open(path, FileAccess.READ)
	var blocks=JSON.parse_string(program.get_as_text())
	var root_cord=-(10*16*5)
	for i in blocks.keys():
		var x=root_cord+(int(i.split(":")[0])*16*5)
		var y=root_cord+(int(i.split(":")[1])*16*5)
		var newBlock=preload("res://Assets/BlockCollision.tscn").instantiate()
		newBlock.position.x=x
		newBlock.position.y=y
		
		newBlock.name="Block"+str(x)+":"+str(y)
		newBlock.Server=Server
		newBlock._change_type(int(blocks[i]))
		map[i]=newBlock
		if(int(blocks[i])==11):
			bases[bases.size()]=newBlock
		CollisionContainer.add_child(newBlock)
		Server._ini_spawn(int(blocks[i]), newBlock.name,newBlock.position)


func _spawn_item(id:int,pos:Vector2):
	var new_item=preload("res://Assets/ItemCol.tscn").instantiate()
	
	new_item.name="Item"+str(pos.x/(16*5)+10)+":"+str(pos.y/(16*5)+10)
	new_item.position=pos
	new_item.Server=Server
	map[str(pos.x/(16*5)+10)+":"+str(pos.y/(16*5)+10)]=new_item
	print(str(pos.x/(16*5)+10)+":"+str(pos.y/(16*5)+10))
	CollisionContainer.add_child(new_item)
	new_item.id=id
	Server._ini_spawn(id,new_item.name, pos)


func _asign_base():
	for i in PlayerManager.players_links.values():
		i["Inst"].respPos=Vector2(0,0)
	for i in range(0,3):
		var rsppos
		if(bases.size()>i):
			rsppos=bases[i].position
			if(PlayerManager.players_links.size()>i):
				PlayerManager.players_links[PlayerManager.players_links.keys()[i]]["Inst"].respPos=rsppos

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

func _hit_cords(x:int, y:int):
	var root_cord=-(10*16*5)
	if(map.keys().has(str(x)+":"+str(y))):
		if(map[str(x)+":"+str(y)].is_damageble):
			map[str(x)+":"+str(y)].damage()
		elif (!(map[str(x)+":"+str(y)].is_blocking_projectile)):
			for i in PlayerManager.players_links.values():
				if((abs(abs(i["Inst"].position.x)-(abs(root_cord+(x*16*5))))<8*5)&&(abs(abs(i["Inst"].position.y)-(abs(root_cord+(y*16*5))))<8*5)):
					i["Inst"].damage()
	else:
			for i in PlayerManager.players_links.values():
				
				if((abs(abs(i["Inst"].position.x)-(abs(root_cord+(x*16*5))))<8*5)&&(abs(abs(i["Inst"].position.y)-(abs(root_cord+(y*16*5))))<8*5)):
					i["Inst"].damage()

func _reliable_spawn(id:int, pos:Vector2, rot:float=0):
	match id:
		0:
			pass


func _spawn_Block(name:String, type:int, x:int, y:int):
	var root_cord=-(10*16*5)
	var newb=preload("res://Assets/BlockCollision.tscn").instantiate()
	newb.name=name
	newb.Server=Server
	newb._change_type(type)
	newb.position=Vector2((x*16*5)+root_cord,(y*16*5)+root_cord )
	map[str(x)+":"+str(y)]=newb
	CollisionContainer.add_child(newb)
	Server._ini_spawn(type, name, newb.position)

func _call_replace(name:String, type:int, new_name:String):
	for i in CollisionContainer.get_children():
		if(i.name==name):
			if(type!=0):
				i._change_type(type)
			else:
				map.erase(str(i.position.x/(16*5)+10)+":"+str(i.position.y/(16*5)+10))
				CollisionContainer.remove_child(i)
				i.queue_free()
	Server._ini_block_change(name, type, new_name)
