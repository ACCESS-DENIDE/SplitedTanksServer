extends Node

var Server
var can_spawn=false
var chance:int
var rng = RandomNumberGenerator.new()
func _ready():
	chance=Server.Constants.star_spawn_chance
	$Min.wait_time=Server.Constants.min_spawn_star
	$Max.wait_time=Server.Constants.max_star_spawn
	pass

func _process(delta):
	if(can_spawn):
		randomize()
		if (rng.randi_range(0, 100)<=chance*delta):
			_spawn()
	pass


func _on_min_timeout():
	can_spawn=true
	pass # Replace with function body.


func _on_max_timeout():
	_spawn()

func _spawn():
	var root_cord=-(10*16*5)
	can_spawn=false
	$Min.start()
	$Max.start()
	var spawns=Server.MapManager._get_availib_spawns()
	if(spawns.size()>0):
		randomize()
		var cord=spawns[rng.randi_range(0, spawns.size()-1)]
		Server.MapManager._hit_cords(cord.x, cord.y, -1)
		Server.MapManager._reliable_spawn((str(cord.x)+":"+str(cord.y)), 58, Vector2((cord.x*16*5)+root_cord, (cord.y*16*5)+root_cord))
