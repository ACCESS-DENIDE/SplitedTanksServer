extends Node

var can_spawn=false
@onready var MapManager=$"../MapManager"
@onready var Server=$".."
@onready var Constants=$"../Constants"
var chance:int
var rng = RandomNumberGenerator.new()
func _ready():
	chance=Constants.CrateSpawnChance
	$Min.wait_time=Constants.MinCrateSpawn
	$Max.wait_time=Constants.MaxCrateSpawn
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
	randomize()
	var x = rng.randi_range(0, 21)
	randomize()
	var y = rng.randi_range(0, 21)
	if(!(MapManager.map.keys().has(str(x)+":"+str(y)))):
		MapManager._hit_cords(x, y)
		MapManager._reliable_spawn((str(x)+":"+str(y)), 12, Vector2((x*16*5)+root_cord, (y*16*5)+root_cord))
