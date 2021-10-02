extends KinematicBody2D

const WALK_FORCE = 200
const WALK_MAX_SPEED = 100
const STOP_FORCE = 1300
const JUMP_SPEED = 300

var velocity = Vector2()
var input = Vector2()

enum ElementState { PARTICLE, WATER, FIRE, AIR, GROUND }
var state

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	state = ElementState.PARTICLE
	$AnimatedSprite.play("idle")

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
	
	var walk = input.x * WALK_FORCE
	
	# slow the player down while not moving
	if abs(walk) < WALK_FORCE * 0.2 or walk > 0 and input.x < 0 or walk < 0 and input.x > 0:
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		if state == ElementState.FIRE:
			velocity.x += walk * delta * 2
		else:
			velocity.x += walk * delta * 2
		$AnimatedSprite.play("run")
	
	if walk < 0:
		$AnimatedSprite.scale.x = -1
	elif walk > 0:
		$AnimatedSprite.scale.x = 1
	elif walk == 0:
		$AnimatedSprite.play("idle")
	
	# clamp velocity
	if state == ElementState.FIRE:
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED*2, WALK_MAX_SPEED*2)
	else:
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	if (velocity.y < 0):
		velocity.y += gravity * 4 * delta
	else:
		velocity.y += gravity * 4 * delta

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	if is_on_floor() and Input.is_action_just_pressed("jump") and state != ElementState.WATER:
		velocity.y = -JUMP_SPEED
	
	if Input.is_action_just_pressed("dash") and state != ElementState.PARTICLE:
		dash()
		state = ElementState.PARTICLE

func dash():
	var dashRadius = 100
	position = position + input * dashRadius
	$Particles2D.restart()
	
	
func apply_element(element):
	state = element
