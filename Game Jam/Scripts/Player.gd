extends KinematicBody2D

const WALK_FORCE = 200
const WALK_MAX_SPEED = 100
const STOP_FORCE = 1300
const JUMP_SPEED = 300

var velocity = Vector2()
var input = Vector2()

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input():
	input = Vector2()
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1

func _physics_process(delta):
	get_input()
	
	var walk = input.x * WALK_FORCE
	
	# slow the player down while not moving
	if abs(walk) < WALK_FORCE * 0.2 or walk > 0 and input.x < 0 or walk < 0 and input.x > 0:
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	
	# clamp velocity
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	if (velocity.y < 0):
		velocity.y += gravity * 4 * delta
	else:
		velocity.y += gravity * 4 * delta

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_SPEED
