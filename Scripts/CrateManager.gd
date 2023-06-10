extends Node

var can_spawn=false
@onready var MapManager=$"../MapManager"
@onready var Server=$".."
@onready var Constants=$"../Constants"
var chance:int
var rng = RandomNumberGenerator.new()
func _ready():
	chance=Constants.crate_spawn_chance
	$Min.wait_time=Constants.min_crate_spawn
	$Max.wait_time=Constants.max_crate_spawn
	pass

func _process(delta):
	if(can_spawn):
		randomize()
		if (rng.randi_range(0, 100)<=chance):
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
	var spawns=MapManager._get_availib_spawns()
	if(spawns.size()>0):
		randomize()
		var cord=spawns[rng.randi_range(0, spawns.size()-1)]
		MapManager._hit_cords(cord.x, cord.y, -2)
		MapManager._reliable_spawn((str(cord.x)+":"+str(cord.y)), 12, Vector2((cord.x*16*5)+root_cord, (cord.y*16*5)+root_cord))

