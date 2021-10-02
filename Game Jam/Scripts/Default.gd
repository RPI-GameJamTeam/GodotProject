extends Node2D

var speed_reduce_x = 200
var speed = 100
var jump_power = 10000
var gravity = 9
var _velocity = Vector2.ZERO
var is_active : bool = false
var slow_down : bool
# the default should go normal

func _physics_process(delta):
	if is_active:
		# left right walking
		print(_velocity.y)
		if Input.is_action_just_pressed("left"):
			_velocity.x = -speed
		if Input.is_action_just_pressed("right"):
			_velocity.x = speed
		if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
			_velocity.x = 0
			
		# jump
		if Input.is_action_just_pressed("jump"):
			print(get_parent().on_floor)
			if get_parent().on_floor:
				_velocity.y -= jump_power
				
		_velocity.y = gravity + _velocity.y 
		_velocity = get_parent().get_parent().move_and_slide(_velocity)
		
		# gravity
		if get_parent().on_floor:
			_velocity.y = 0
		
			
		# stop when no input
#		if slow_down:
#			if _velocity.x > 0:
#				pass
#			elif _velocity.x < 0:
#				pass
				
		
