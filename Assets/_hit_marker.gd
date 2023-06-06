extends Area2D

var hiter



func _on_deliter_timeout():
	get_parent().remove_child(self)
	queue_free()


func _on_body_entered(body):
	if(body.is_damageble):
		body.damage(hiter)
