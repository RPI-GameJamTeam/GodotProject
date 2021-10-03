extends KinematicBody2D

enum State { IDLE, PATROL, CHASE }
var state

var ray_cast_rotating = 18

export var move_able : bool = false

var player_in_area : bool = false 
var patrolPoints

const FLY_FORCE = 200
const FLY_MAX_SPEED = 100
const STOP_FORCE = 1300

var velocity = Vector2()

func _ready():
	state = State.IDLE

func _physics_process(delta):

	var targetPoint = Vector2(1000, -1000)
	var moveDir = (targetPoint - position).normalized()
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
	
	if move_able:
		velocity = move_and_slide(velocity, Vector2.UP)


func _on_CheckPlayer_body_entered(body):
	player_in_area = true


func _on_CheckPlayer_body_exited(body):
	player_in_area = false
	
func _process(delta):
	if player_in_area:
		if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
			print('find it')

