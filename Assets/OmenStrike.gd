extends Node
var root_cord
var Server
var x_local
var y_local

func _strike(x:int, y:int, striker_id:int):
	x_local=x
	y_local=y
	root_cord=-(10*16*5)
	Server._ini_spawn(28, "Strike"+str(striker_id), Vector2(((x*80)+root_cord),(y*80)+root_cord) )


func _on_striker_timeout():
	for i in range( -2, 3):
		for g in range( -2, 3):
			Server.MapManager._hit_cords(x_local+i, y_local+g)
	get_parent().remove_child(self)
	pass # Replace with function body.
