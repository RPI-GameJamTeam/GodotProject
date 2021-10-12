extends Node2D

export var devMode : bool

var player

func _process(delta):
	if !devMode:
		return null
	
	if get_tree().get_nodes_in_group("Player")[0] != null:
		player = get_tree().get_nodes_in_group("Player")[0]
		
		if Input.is_action_just_pressed("1"):
			player.set_state(player.ElementState.PARTICLE)
			player.transitionToParticle()
			GlobalTool.set_all_glow(player.ElementState.PARTICLE)
		if Input.is_action_just_pressed("2"):
			player.set_state(player.ElementState.WATER)
			GlobalTool.set_all_glow(player.ElementState.WATER)
		if Input.is_action_just_pressed("3"):
			player.set_state(player.ElementState.FIRE)
			GlobalTool.set_all_glow(player.ElementState.FIRE)
		if Input.is_action_just_pressed("4"):
			player.set_state(player.ElementState.AIR)
			GlobalTool.set_all_glow(player.ElementState.AIR)
		if Input.is_action_just_pressed("5"):
			player.set_state(player.ElementState.EARTH)
			GlobalTool.set_all_glow(player.ElementState.EARTH)
		if Input.is_action_just_pressed("6"):
			pass
		if Input.is_action_just_pressed("7"):
			pass
		if Input.is_action_just_pressed("8"):
			pass
		if Input.is_action_just_pressed("9"):
			player.toggleInvulnerable()
		if Input.is_action_just_pressed("0"):
			player.toggleCollideable()
		if Input.is_action_just_pressed("-"):
			pass
		if Input.is_action_just_pressed("+"):
			get_tree().get_nodes_in_group("HUD")[0].increaseHP(10)

func _input(event):	
	if !devMode:
		return null
		
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			player.position = get_global_mouse_position()
