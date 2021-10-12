extends Area2D





func _on_teleport_body_entered(body):
	if body in get_tree().get_nodes_in_group('Player'):
		body.position = Vector2(-196, -10)
