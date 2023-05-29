extends Area2D

@onready var agent=$NavigationAgent2D

var target:int
var my_dir
var Server
var x:int
var y:int
var tar_x:int
var tar_y:int
var proc:bool=false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

var WP:Vector2
var path=[]
var flug:bool=false
func _process(delta):
	if(flug):
		agent.set_navigation_map(Server.NavMap)
		agent.set_target_location(Server.PlayerManager.players_links[target]["Inst"].global_position)
		flug=false
	print(agent.distance_to_target())
	agent.set_navigation_map(Server.NavMap)
	agent.
	pass

func cum():
	if(fmod(position.x, 80)==0 and fmod(position.y, 80)==0 and(!proc)):
			x=position.x/(16*5)+10
			y=position.y/(16*5)+10
			tar_x=Server.PlayerManager.players_links[target]["Inst"].position.x/(16*5)+10
			tar_y=Server.PlayerManager.players_links[target]["Inst"].position.y/(16*5)+10
			var PF:Thread=Thread.new()
			proc=true
			_ini_path()
			#PF.start(_calculate_path, 1)
	else:
		if(position.x==WP.x and position.y==WP.y):
			match (_get_dir(position, WP)):
				0:
					position.x+=10
					pass
				1:
					position.x-=10
					pass
				2:
					position.y+=10
					pass
				3:
					position.y-=10
					pass
		else:
			
			if(path.size()==0):
				proc=false
			else:
				var tm_mem=path.pop_front()
				WP=Vector2(tm_mem.x, tm_mem.y)
		position=position+10*my_dir
		Server._call_sync(name, position, rotation)
	pass

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

class PP:
	var x:int
	var y:int
	var dist:float
	var parent:PP=null

func _ini_path():
	mem.clear()
	for i in range(0, 22):
		mem.push_back([])
		for g in range(0, 22):
			mem[i].push_back(null)
	availib.clear()
	var beg=PP.new()
	beg.x=x
	beg.y=y
	beg.dist=(abs(tar_x-x)+abs(tar_y-x))
	mem[x][y]=beg
	_calculate_path(x, y)

var availib={}
var mem=[]
var last_dirt
func _calculate_path(prog_x, prog_y, newb=null):
	print( str(prog_x)+":"+str(prog_y))
	if(prog_x==tar_x and prog_y==tar_y):
		my_dir=last_dirt
		position=position+10*my_dir
		if (newb!=null):
			var check:PP
			check=newb
			path.clear()
			WP.x=newb.x
			WP.y=newb.y
			while (check.parent!=null):
				path.push_front(check)
				Server.MapManager._reliable_spawn( str(position.x/80)+":"+str(position.y/80), 26, Vector2(check.x*80-800,check.y*80-800))
				check=check.parent
		print("pathDetected")
		
		return
	
	if(newb!=null):
		if(mem[prog_x][prog_y]==null):
			var temp=PP.new()
			temp.x=prog_x
			temp.y=prog_y
			var calc_dist=newb.dist+abs(tar_x-prog_x)+abs(tar_y-prog_y)
			if(Server.MapManager.map.has(str(prog_x)+":"+str(prog_y))):
				calc_dist+=1000
			temp.dist=calc_dist
			temp.parent=newb
			mem[prog_x][prog_y]=temp
		else:
			if(mem[prog_x][prog_y].dist>newb.dist+(abs(tar_x-prog_x)+abs(tar_y-prog_y))):
				mem[prog_x][prog_y].dist=newb.dist+(abs(tar_x-prog_x)+abs(tar_y-prog_y))
				mem[prog_x][prog_y].parent=newb
	var rng = RandomNumberGenerator.new()
	randomize()
	var ran=rng.randf_range(0,1)
	for i in range (0, 4):
		var temp_x
		var temp_y
		
		match i:
			0:
				temp_x=prog_x
				temp_y=prog_y-1
				pass
			1:
				temp_x=prog_x
				temp_y=prog_y+1
				pass
			2:
				temp_x=prog_x-1
				temp_y=prog_y
				pass
			3:
				temp_x=prog_x+1
				temp_y=prog_y
				pass
		if(temp_x>21):
			temp_x=21
		elif(temp_x<0):
			temp_x=0
		if(temp_y>21):
			temp_y=21
		elif(temp_y<0):
			temp_y=0
		if(mem[temp_x][temp_y]==null):
			var calc_dist=mem[prog_x][prog_y].dist+abs(tar_x-temp_x)+abs(tar_y-temp_y)+ran
			if(Server.MapManager.map.has(str(temp_x)+":"+str(temp_y))):
				calc_dist+=1000
			var tmp=PP.new()
			tmp.x=temp_x
			tmp.y=temp_y
			tmp.dist=calc_dist
			tmp.parent=mem[prog_x][prog_y]
			availib[calc_dist]=tmp
	
	var key_arr=availib.keys()
	key_arr.sort()
	print(key_arr.size())
	var nex=availib[key_arr[0]]
	last_dirt=Vector2(nex.x-prog_x,nex.y-prog_y )
	availib.erase(key_arr[0])
	_calculate_path(nex.x, nex.y, nex)
	
	pass

var stored_min:int=9999
var stored_dir:int=-1
func _path_find(sum_map:Array, pos_x:int, pos_y:int, path_summ:int,last_dir:int=-1, mod_list={})->int:
	var flg:bool=true
	mod_list[str(pos_x)+":"+str(pos_y)]=1000
	var posib=_get_posib(sum_map, pos_x, pos_y, last_dir, mod_list)
	var mem={}
	for i in range(0, 4):
		mem[posib[i]]=i
	posib.sort()
	for i in range(0, 4):
		path_summ+=posib[i]
		if(path_summ>stored_min):
			return -1
		match mem[posib[i]]:
			0:
				pos_y-=1
				if(pos_y==-1):
					return-1
				pass
			1:
				pos_y+=1
				if(pos_y==22):
					return-1
				pass
			2:
				pos_x-=1
				if(pos_x==-1):
					return-1
				pass
			3:
				pos_x+=1
				if(pos_x==22):
					return-1
				pass
		if(pos_x==tar_x and pos_y==tar_y):
			print(path_summ)
			if(path_summ<stored_min):
				stored_min=path_summ
				stored_dir=-1
				print("Yess")
				return -1
		_path_find(sum_map, pos_x, pos_y,path_summ,mem[posib[i]], mod_list)
		if(stored_dir==-1 ):
			
			stored_dir=i
			print("NewDir"+ str(stored_dir))
	return stored_dir

func _get_posib(sum_map,pos_x:int, pos_y:int, last_dir:int, mod={})->Array:
	var adder=0
	if( pos_x==20 or pos_y==20):
		adder=100
	var ans=[]
	if(pos_y>0):
		ans.push_back(sum_map[pos_y-1][pos_x])
		if(mod.keys().has(str(pos_x)+":"+str(pos_y-1))):
			ans[0]+=100000+adder
	else:
		ans.push_back(10000)
	if(pos_y<20):
		ans.push_back(sum_map[pos_y+1][pos_x])
		if(mod.keys().has(str(pos_x)+":"+str(pos_y+1))):
			ans[1]+=100000+adder
	else:
		ans.push_back(10000)
	if(pos_x>0):
		ans.push_back(sum_map[pos_y][pos_x-1])
		if(mod.keys().has(str(pos_x-1)+":"+str(pos_y))):
			ans[0]+=100000+adder
	else:
		ans.push_back(10000)
	if(pos_x<20):
		ans.push_back(sum_map[pos_y][pos_x+1])
		if(mod.keys().has(str(pos_x+1)+":"+str(pos_y))):
			ans[1]+=100000+adder
	else:
		ans.push_back(10000)
	match last_dir:
		0:
			ans[1]+=10000
			pass
		1:
			ans[0]+=10000
			pass
		2:
			ans[3]+=10000
			pass
		3:
			ans[2]+=10000
			pass
		
	return ans
