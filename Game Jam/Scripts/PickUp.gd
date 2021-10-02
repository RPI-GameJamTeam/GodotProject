extends Area2D

func _on_PickUp_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("Camera2D").add_trauma(0.6)
		body.get_node("Camera2D").shake()
