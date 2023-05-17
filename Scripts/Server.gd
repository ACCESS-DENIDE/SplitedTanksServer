extends Node

var CollRef=preload("res://Assets/TankColl.tscn")
var MapPartRef=preload("res://Assets/BlockCollision.tscn")
var is_damageble=true
var bases={}
var target_wait={}
var map={}

@onready var CollisionContainer=$CollisionContainer
@onready var InputManager=$InputManager

var active_players=0
var players_links={}

# Called when the node enters the scene tree for the first time.
func _ready():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(25565)
	print("creating server")
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		print("server err")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_network_connected)
	multiplayer.peer_disconnected.connect(_on_network_disconnected)
	print("server created")
	_loadMap("Cock")

func _loadMap(path:String):
	path="res://Maps/IdTester.json"
	var program=FileAccess.open(path, FileAccess.READ)
	var blocks=JSON.parse_string(program.get_as_text())
	var root_cord=-(10*16*5)
	for i in blocks.keys():
		var x=root_cord+(int(i.split(":")[0])*16*5)
		var y=root_cord+(int(i.split(":")[1])*16*5)
		var newBlock=MapPartRef.instantiate()
		newBlock.position.x=x
		newBlock.position.y=y
		newBlock.name="Block"+str(x)+":"+str(y)
		newBlock.Server=self
		newBlock._change_type(int(blocks[i]))
		map[i]=newBlock
		if(int(blocks[i])==11):
			bases[bases.size()]=newBlock
		CollisionContainer.add_child(newBlock)
		rpc("_client_spawn", int(blocks[i]), newBlock.name,newBlock.position)
		

func _spawn_item(id:int,pos:Vector2):
	var new_item=preload("res://Assets/ItemCol.tscn").instantiate()
	new_item.name="Item"+str(pos.x)+":"+str(pos.y)
	new_item.position=pos
	new_item.Server=self
	map[str(pos.x/(16*5)+10)+":"+str(pos.y/(16*5)+10)]=new_item
	print(str(pos.x/(16*5)+10)+":"+str(pos.y/(16*5)+10))
	CollisionContainer.add_child(new_item)
	new_item.id=id
	_ini_spawn(id,new_item.name, pos)

func _asign_base():
	for i in players_links.values():
		i["Inst"].respPos=Vector2(0,0)
	for i in range(0,3):
		var rsppos
		if(bases.size()>i):
			rsppos=bases[i].position
			if(players_links.size()>i):
				players_links[players_links.keys()[i]]["Inst"].respPos=rsppos

func _unload_map():
	rpc("_unload_map_cli")
	bases.clear()
	for i in CollisionContainer.get_children():
		if(i.name.contains("Block")):
			CollisionContainer.remove_child(i)
	pass

func _hit_cords(x:int, y:int):
	var root_cord=-(10*16*5)
	if(map.keys().has(str(x)+":"+str(y))):
		if(map[str(x)+":"+str(y)].is_damageble):
			map[str(x)+":"+str(y)].damage()
		elif (!(map[str(x)+":"+str(y)].is_blocking_projectile)):
			for i in players_links.values():
				if((abs(abs(i["Inst"].position.x)-(abs(root_cord+(x*16*5))))<8*5)&&(abs(abs(i["Inst"].position.y)-(abs(root_cord+(y*16*5))))<8*5)):
					i["Inst"].damage()
	else:
			for i in players_links.values():
				
				if((abs(abs(i["Inst"].position.x)-(abs(root_cord+(x*16*5))))<8*5)&&(abs(abs(i["Inst"].position.y)-(abs(root_cord+(y*16*5))))<8*5)):
					i["Inst"].damage()

func _on_network_connected(peer_id:int):
	if(active_players<4):
		var new_tank=CollRef.instantiate()
		new_tank.name="Player"+str(peer_id)
		new_tank.Server=self
		new_tank.my_master=peer_id
		CollisionContainer.add_child(new_tank)
		active_players=0
		for i in players_links.keys():
			rpc_id(peer_id,"_client_spawn", active_players, str(i), players_links[i]["Inst"].position)
			active_players+=1
		for i in CollisionContainer.get_children():
			if(i.name.contains("Block")):
				rpc_id(peer_id,"_client_spawn", i.type, i.name, i.position)
			if(i.name.contains("Item")):
				rpc_id(peer_id,"_client_spawn", i.id, i.name, i.position)
		players_links[peer_id]={}
		players_links[peer_id]["Team"]=active_players
		players_links[peer_id]["Inst"]=new_tank
		players_links[peer_id]["GT"]=3
		players_links[peer_id]["PU"]=-1
		players_links[peer_id]["Name"]=""
		players_links[peer_id]["Phase"]=0
		_asign_base()
		new_tank.position=new_tank.respPos
		rpc("_client_spawn", active_players, str(peer_id), new_tank.respPos)
		active_players+=1

func _rquest_target(peer:int, callback:Callable):
	target_wait[peer]=callback
	rpc_id(peer, "_target_req")

func _on_network_disconnected(peer_id:int):
	if( players_links.keys().has(peer_id)):
		active_players-=1
		CollisionContainer.remove_child(players_links[peer_id]["Inst"])
		rpc("_client_despawn", str(peer_id))
		players_links.erase(peer_id)
		_asign_base()

func _ini_spawn(id:int, name:String, pos:Vector2):
	rpc("_client_spawn", id, name, pos)


@rpc("any_peer")
func _Shoot_pressed():
	InputManager._shoot(multiplayer.get_remote_sender_id())

@rpc("any_peer","unreliable")
func _call_move(dir:int):
	var id=multiplayer.get_remote_sender_id()
	if(players_links.keys().has(id)):
		InputManager._move_player(id, dir)

func _call_replace(name:String, type:int, new_name:String):
	for i in CollisionContainer.get_children():
		if(i.name==name):
			if(type!=0):
				i._change_type(type)
			else:
				map.erase(str(i.position.x/(16*5)+10)+":"+str(i.position.y/(16*5)+10))
				CollisionContainer.remove_child(i)
	rpc("_changeBlock", name, type, new_name)


@rpc("any_peer")
func _setName(name:String):
	players_links[multiplayer.get_remote_sender_id()]["Name"]=name

func _call_sync(name:String, pos:Vector2, rot:float):
	rpc("_sync", name, pos, rot)
	
@rpc("any_peer","unreliable")
func _sync(name:String, pos:Vector2, rot:float):
	pass

@rpc("any_peer")
func _target_send(x:int, y:int):
	target_wait[multiplayer.get_remote_sender_id()].call(x, y, multiplayer.get_remote_sender_id())

@rpc("any_peer")
func  _changeBlock(name:String, type:int, new_name:String):
	pass
@rpc("any_peer")
func _unload_map_cli():
	pass
@rpc("any_peer")
func _client_spawn(id:int, name:String, pos:Vector2):
	pass
@rpc("any_peer")
func _client_despawn(name:String):
	pass
@rpc("any_peer")
func _target_req():
	pass



