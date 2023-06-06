extends StaticBody2D

var is_damageble=true
var is_blocking_projectile=false
var is_blocking_tank=false

var resp_pos
var WP:Vector2
var path=[]
var availib_nodes=[]
var x:int
var y:int
var tar_x:int
var tar_y:int
var proc:bool=false
var SPEED=100
var Server

func _process(delta):
	if((fmod(position.x, 80)==0 and fmod(position.y, 80)==0 and(!proc))):
				x=position.x/(16*5)+10
				y=position.y/(16*5)+10
				
				_get_target()
				
				
				var PF:Thread=Thread.new()
				proc=true
				print ("startCalc")
				_calculate_path()
	else:
		if(position.x==WP.x and position.y==WP.y):
			if(path.size()==0):
				proc=false
			else:
				
				var tm_mem=path.pop_back()
				WP=Vector2(tm_mem.x, tm_mem.y)
			
		else:
			proc=false
			match (_get_dir(position, WP)):
				0:
					if(WP.x-position.x>SPEED*delta):
						position.x+=SPEED*delta
					else:
						position.x=WP.x
					pass
				1:
					if(WP.x-position.x<SPEED*delta):
						position.x-=SPEED*delta
					else:
						position.x=WP.x
					pass
				2:
					if(WP.y-position.y>SPEED*delta):
						position.y+=SPEED*delta
					else:
						position.y=WP.y
					pass
				3:
					if(WP.y-position.y<SPEED*delta):
						position.y-=SPEED*delta
					else:
						position.y=WP.y
					pass
			Server._call_sync(name, position, rotation)
	pass

func _get_target():
	if(position==Vector2(tar_x*80-800,tar_y*80-800)):
		_change_tar()
	else:
		pass

func _change_tar():
	var target_list=Server.MapManager._get_availib_spawns()
	if(target_list.size()>0):
		var rng=RandomNumberGenerator.new()
		randomize()
		var t=target_list[rng.randi_range(0, target_list.size()-1)]
		tar_x=t.x
		tar_y=t.y

func _get_dir(vect1, vect2)->int:
	if(vect1.x<vect2.x):
		return 0
	if(vect1.x>vect2.x):
		return 1
	if(vect1.y<vect2.y):
		return 2
	if(vect1.y>vect2.y):
		return 3
	return -1

func _ready():
	SPEED=Server.Constants.PigSpeed

class PP:
	var pos:Vector2
	var path_len:int
	var parent:PP
	var tar_pos:Vector2
	func _init(x_red:int, y_red:int, tar:Vector2, par:PP=null):
		pos=Vector2(x_red, y_red)
		parent=par
		tar_pos=tar
		if(par!=null):
			path_len=par.path_len+(abs(tar.x-pos.x)+abs(tar.y-pos.y))
		else:
			path_len=(abs(tar.x-pos.x)+abs(tar.y-pos.y))
	func _reparent(new_par:PP):
		if(path_len>new_par.path_len+(abs(tar_pos.x-pos.x)+abs(tar_pos.y-pos.y))):
			path_len=new_par.path_len+(abs(tar_pos.x-pos.x)+abs(tar_pos.y-pos.y))
			parent=new_par



func _calculate_path():
	availib_nodes.clear()
	var node_map=[]
	for i in range(0, 22):
		node_map.push_back([])
		for g in range(0, 22):
			node_map[i].push_back(null)
	
	var start_node=PP.new(x, y, Vector2(tar_x, tar_y))
	node_map[x][y]=start_node
	var cur_node=start_node
	
	while(cur_node.pos!=Vector2(tar_x, tar_y)):
		_get_posib(node_map, cur_node.pos.x, cur_node.pos.y)
		if(availib_nodes.size()==0):
			break
		var minimal_ref=availib_nodes[0]
		for i in availib_nodes:
			if(minimal_ref.path_len>i.path_len):
				minimal_ref=i
		availib_nodes.erase(minimal_ref)
		node_map[minimal_ref.pos.x][minimal_ref.pos.y]=minimal_ref
		for i in availib_nodes:
			if (i.pos==minimal_ref.pos):
				availib_nodes.erase(i)
			if(((abs(i.pos.x-minimal_ref.pos.x)==1)and(i.pos.y==minimal_ref.pos.y)) or ((abs(i.pos.y-minimal_ref.pos.y)==1)and(i.pos.x==minimal_ref.pos.x))):
				i._reparent(minimal_ref)
		cur_node=minimal_ref
		minimal_ref=null
	if(cur_node.pos!=Vector2(tar_x, tar_y)):
		_change_tar()
	else:
		var storing_node:PP=cur_node
		while(storing_node.parent!=null):
			path.clear()
			path.push_back(Vector2(storing_node.pos.x*80-800, storing_node.pos.y*80-800))
			storing_node=storing_node.parent
		if(path.size()!=0):
			var tm_mem=path.pop_back()
			WP=Vector2(tm_mem.x, tm_mem.y)
			


func _get_posib(point_map,pos_x:int, pos_y:int):
	var new_x
	var new_y
	for i in range(0, 4):
		match i:
			0:
				new_x=pos_x+1
				new_y=pos_y
				pass
			1:
				new_x=pos_x-1
				new_y=pos_y
				pass
			2:
				new_x=pos_x
				new_y=pos_y+1
				pass
			3:
				new_x=pos_x
				new_y=pos_y-1
				pass
			
		if (new_x>21 or new_x<0 or new_y>21 or new_y<0):
			continue
		else:
			if(point_map[new_x][new_y]==null):
				if(Server.MapManager.map.has(str(new_x)+":"+str(new_y))):
					if(Server.MapManager.map[str(new_x)+":"+str(new_y)].is_blocking_tank!=true):
						availib_nodes.push_back(PP.new(new_x, new_y, Vector2(tar_x, tar_y), point_map[pos_x][pos_y]))
				else:
					availib_nodes.push_back(PP.new(new_x, new_y, Vector2(tar_x, tar_y), point_map[pos_x][pos_y]))
	pass


func damage(killer:int):
	var target_list=Server.MapManager._get_availib_spawns()
	if(Server.PlayerManager.players_links.has(killer)):
		Server.PlayerManager.players_links[killer]["Score"]+=Server.Constants.HohlyonokKillScore
	Server.PlayerManager._update_scores()
	if(target_list.size()>0):
		_change_tar()
		var rng=RandomNumberGenerator.new()
		randomize()
		var t=target_list[rng.randi_range(0, target_list.size()-1)]
		position=Vector2(t.x*80-800,t.y*80-800 )
		Server._call_sync(name, position, rotation)
	pass
