extends Node

@onready var CollisionContainer=$CollisionContainer
@onready var InputManager=$InputManager
@onready var MapManager=$MapManager
@onready var PlayerManager=$PlayerManager
@onready var Constants=$Constants

var target_wait={}

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
	MapManager._loadMap("Cock")



func _on_network_connected(peer_id:int):
	PlayerManager._add_player(peer_id)

func _rquest_target(peer:int, callback:Callable):
	target_wait[peer]=callback
	rpc_id(peer, "_target_req")

func _on_network_disconnected(peer_id:int):
	PlayerManager._remoe_player(peer_id)

func _ini_spawn(id:int, name:String, pos:Vector2, rot:float=0.0):
	rpc("_client_spawn", id, name, pos, rot)

func _id_ini_spawn(peer:int, id:int, name:String, pos:Vector2):
	rpc_id(peer, "_client_spawn", id, name, pos)

func _ini_despawn(name:String):
	rpc("_client_despawn", name)

func _ini_map_unload():
	rpc("_unload_map_cli")

func _ini_block_change(name:String, type:int, new_name:String):
	rpc("_changeBlock", name, type, new_name)


@rpc("any_peer")
func _PU_pressed():
	InputManager._PU_Use(multiplayer.get_remote_sender_id())
@rpc("any_peer")
func _Shoot_pressed():
	InputManager._shoot(multiplayer.get_remote_sender_id())
@rpc("any_peer","unreliable")
func _call_move(dir:int):
	var id=multiplayer.get_remote_sender_id()
	if(PlayerManager.players_links.keys().has(id)):
		InputManager._move_player(id, dir)
@rpc("any_peer")
func _setName(name:String):
	PlayerManager.players_links[multiplayer.get_remote_sender_id()]["Name"]=name
func _call_sync(name:String, pos:Vector2, rot:float):
	rpc("_sync", name, pos, rot)
@rpc("any_peer")
func _target_send(x:int, y:int):
	target_wait[multiplayer.get_remote_sender_id()].call(x, y, multiplayer.get_remote_sender_id())
@rpc("any_peer","unreliable")
func _sync(name:String, pos:Vector2, rot:float):
	pass
@rpc("any_peer")
func  _changeBlock(name:String, type:int, new_name:String):
	pass
@rpc("any_peer")
func _unload_map_cli():
	pass
@rpc("any_peer")
func _client_spawn(id:int, name:String, pos:Vector2, rot:float=0.0):
	pass
@rpc("any_peer")
func _client_despawn(name:String):
	pass
@rpc("any_peer")
func _target_req():
	pass



