extends KinematicBody2D

const WALK_FORCE = 450
const WALK_MAX_SPEED = 200
const STOP_FORCE = 2600
const JUMP_SPEED = 400

var velocity = Vector2()
var input = Vector2()
var gravityDir = Vector2()
var spawnPos = Vector2()

enum ElementState { PARTICLE, WATER, FIRE, AIR, EARTH }
var state

signal ElementTransition(value)

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	spawnPos = position
	reset()

func reset():
	state = ElementState.PARTICLE
	$AnimatedSprite.play("idle")
	position = spawnPos

func get_input():
	if state != ElementState.FIRE:
		input = Vector2()
	
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("up"):
		input.y -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
	
	input = input.normalized()

func _physics_process(delta):
	get_input()
	
	if state == ElementState.EARTH:
		if input.x > 0 and $RightCast.is_colliding():
			# jump to right wall
			rotation += deg2rad(-90)
		elif input.x < 0 and $LeftCast.is_colliding():
			# jump to left wall
			rotation += deg2rad(90)
	
	var walk = input.x * WALK_FORCE
	
	if state != ElementState.AIR:
		# slow the player down while not moving
		if abs(walk) < WALK_FORCE * 0.2 or (velocity.x > 0 and input.x < 0) or (velocity.x < 0 and input.x > 0):
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta * 4)
		else:
			if state == ElementState.FIRE:
				velocity.x += walk * delta * 1.5
			else:
				velocity.x += walk * delta 
			$AnimatedSprite.play("run")
	else:
		velocity += input * WALK_FORCE * delta * 0.25
	
	if walk < 0:
		$AnimatedSprite.scale.x = -1
	elif walk > 0:
		$AnimatedSprite.scale.x = 1
	elif walk == 0:
		$AnimatedSprite.play("idle")
	
	# clamp velocity
	if state == ElementState.FIRE:
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED*1.5, WALK_MAX_SPEED*1.5)
	else:
		if state == ElementState.AIR:
			velocity.x = clamp(velocity.x, -WALK_MAX_SPEED*0.5, WALK_MAX_SPEED*0.5)
			velocity.y = clamp(velocity.y, -WALK_MAX_SPEED*0.5, WALK_MAX_SPEED*0.5)
		else:			
			velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# apply gravity
	var gravityVector = Vector2()
	if state != ElementState.AIR:
		if state == ElementState.EARTH and !$DownCast.is_colliding() or state != ElementState.EARTH:
			gravityVector += gravity * 4 * delta * 2 * Vector2(0, 1).rotated(rotation)

	if state == ElementState.AIR:
		velocity = move_and_slide(velocity, Vector2.UP)
	elif state == ElementState.EARTH:
		var down = Vector2(0, 1).rotated(rotation)
		var dir = velocity.rotated(rotation)
		var temp = move_and_slide_with_snap(dir + gravityVector, down, -down)
		velocity = temp.rotated(-rotation)
	else:
		velocity = move_and_slide_with_snap(velocity + gravityVector, Vector2.DOWN, Vector2.UP)

	if $DownCast.is_colliding() and Input.is_action_just_pressed("jump") and state != ElementState.WATER and state != ElementState.AIR:
		velocity += -JUMP_SPEED * Vector2(0, 1)
	
	if state == ElementState.AIR:
		for i in get_slide_count():
			if !get_slide_collision(i).collider.is_in_group("PickUp"):
				reset()
	
	if Input.is_action_just_pressed("dash"):
		if state != ElementState.PARTICLE:
			dash()
			state = ElementState.PARTICLE
		else:
			pass # leave chem trail

func dash():
	var dashRadius = 100
	position = position + input * dashRadius
	$Particles2D.restart()
	$Camera2D.add_trauma(0.4)
	$Camera2D.shake()
	
