extends Node2D

var speed = 100
var jump_power = 200
var gravity = 50
var _velocity = Vector2.ZERO
var is_active : bool = false
# the fire should go realy fast and cant stop automatically.

func _physics_process(delta):
	if is_active:
		# left right walking
		if Input.is_action_just_pressed("left"):
			_velocity.x = -speed
		if Input.is_action_just_pressed("right"):
			_velocity.x = speed
			
		# jump
		if Input.is_action_just_pressed("jump"):
			if get_parent().on_floor:
				_velocity.y += jump_power
			
		# gravity
		if ! get_parent().on_floor:
			_velocity.y += gravity * delta
			
			
	
