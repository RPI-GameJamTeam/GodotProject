extends Node

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("restart"):
		reset()

func reset():
	pass
