extends Node

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("restart"):
		get_tree().get_nodes_in_group("Player")[0].die()

