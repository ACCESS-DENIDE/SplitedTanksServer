extends Node
var striker_id
var x:int
var y:int
const root_cord=-(10*16*5)
var Server
var x_cont
var y_cont
var Speed_art=200

func _calculate_strike():
	x_cont=x
	y_cont=y
	var root_cord=-(10*16*5)
	var dest=Server.players_links[striker_id]["Inst"].position-Vector2(root_cord+x*16*5, root_cord+y*16*5)
	dest.x=int(dest.x)
	dest.y=int(dest.y)
	$Striker.wait_time=Vector2(dest).length()/Speed_art
	print(str(dest)+"N"+str($Striker.wait_time).replace(".", "A")+"N"+str(striker_id))
	Server._ini_spawn(16,str(dest)+"N"+str($Striker.wait_time).replace(".", "A")+"N"+str(striker_id) , Server.players_links[striker_id]["Inst"].position)
	Server.players_links[striker_id]["Inst"].Speed=600

func _on_striker_timeout():
	Server._ini_spawn(17, ("Exp:"+name),Vector2(root_cord+x_cont*16*5, root_cord+y_cont*16*5))
	Server._hit_cords(x_cont, y_cont)
	Server.players_links[striker_id]["Phase"]=0
	get_parent().remove_child(self)

