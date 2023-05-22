extends Area2D

var ally
var Server
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if(body.is_damageble):
		if(body!=ally):
			body.damage()
			Server._ini_spawn(17, ("Exp:"+name), position)
			get_parent().remove_child(self)
			queue_free()
	pass # Replace with function body.
