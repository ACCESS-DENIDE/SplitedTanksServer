extends Area2D

var Server
var Parent:String
var dir:int=0
var SPEED
var flg:bool=true
var kill_dist=1000000

# Called when the node enters the scene tree for the first time.
func _ready():
	SPEED=Server.Constants.bulet_speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees=dir
	print(SPEED*delta)
	match dir:
		0:
			position.y-=SPEED*delta
			pass
		90:
			position.x+=SPEED*delta
			pass
		180:
			position.y+=SPEED*delta
			pass
		-180:
			position.y+=SPEED*delta
			pass
		-90:
			position.x-=SPEED*delta
			pass
	if(position.length()>kill_dist):
		Server.MapManager._call_replace(self.name, 0, self.name)
		flg=false
	Server._call_sync(name, position, rotation)
	pass


func _on_body_entered(body):
	if (flg):
		if(!(body.name==Parent)):
			if(body.is_damageble):
				body.damage()
			Server.MapManager._call_replace(self.name, 0, self.name)
			Server._ini_spawn(26, ("Exp:"+name),position)
			flg=false
	pass # Replace with function body.
