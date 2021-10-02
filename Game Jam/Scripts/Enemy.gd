extends KinematicBody2D

enum State { IDLE, PATROL, CHASE }
var state

var patrolPoints

const FLY_FORCE = 200
const FLY_MAX_SPEED = 100
const STOP_FORCE = 1300

var velocity = Vector2()

func _ready():
	state = State.IDLE

var input = Vector2()
func get_input():
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
	
	var targetPoint = Vector2()
	#var moveDir = (targetPoint - position).normalized()
	var moveDir = input
	var movement = moveDir * FLY_FORCE
	
	# slow the player down while not moving
	if movement.length() < FLY_FORCE * 0.2:
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		velocity.y = move_toward(velocity.y, 0, STOP_FORCE * delta)
	else:
		velocity += movement * delta
		$AnimatedSprite.play("fly")
	
	if velocity.x < 0:
		$AnimatedSprite.scale.x = -1
		rotation = velocity.angle() - deg2rad(180)
		pass
	elif velocity.x > 0:
		$AnimatedSprite.scale.x = 1
		rotation = velocity.angle()
	elif velocity.length() == 0:
		$AnimatedSprite.play("idle")
	
	# clamp velocity
	velocity.x = clamp(velocity.x, -FLY_MAX_SPEED, FLY_MAX_SPEED)
	velocity.y = clamp(velocity.y, -FLY_MAX_SPEED, FLY_MAX_SPEED)

	velocity = move_and_slide(velocity, Vector2.UP)
