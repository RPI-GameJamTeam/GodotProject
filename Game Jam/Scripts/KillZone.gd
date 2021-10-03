extends Area2D

func _on_KillZone_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
