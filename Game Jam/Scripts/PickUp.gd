extends Area2D

enum ElementState { PARTICLE, WATER, FIRE, AIR, EARTH }
var type = ElementState.FIRE

func _on_PickUp_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("Camera2D").add_trauma(0.6)
		body.get_node("Camera2D").shake()
		$Particles2D.restart()
		
		body.set_state(type)
