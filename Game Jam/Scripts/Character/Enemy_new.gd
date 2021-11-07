extends Node2D

export(int) var speed = 1
export(float) var angularSpeed = deg2rad(5)
export(PoolVector2Array) var targetPoints
export(Curve) var movingBuffer
export(Vector2) var scale_for_sprite

var distanceMargin = 0.5
var angularMargin = deg2rad(5)

var targetPointIndex = 0
var originalPosition : Vector2
var faceDir : Vector2

onready var enemy = $Enemy

func _ready():
	faceDir = Vector2.RIGHT.rotated(rotation)
	if targetPoints[0] != Vector2.ZERO:
		targetPoints.insert(0, Vector2.ZERO)
	originalPosition = enemy.position
	enemy.scale = scale_for_sprite


func _physics_process(delta):
	faceDir = Vector2.RIGHT.rotated(rotation).rotated(enemy.rotation)
	move_to(targetPoints[targetPointIndex], delta)
	turn_to(targetPoints[targetPointIndex], delta)
	if check_on_target(targetPoints[targetPointIndex]):
		if targetPoints.size() > targetPointIndex + 1:
			originalPosition = targetPoints[targetPointIndex]
			targetPointIndex += 1
		else:
			originalPosition = targetPoints[targetPointIndex]
			targetPointIndex = 0


func move_to(target_position, delta):
	var moveToDir : Vector2 = (target_position - enemy.position).normalized()
	var moveProcess = abs((enemy.position - originalPosition).length()/(target_position - originalPosition).length()) if (target_position - originalPosition).length() !=0 else 1
	var buffer : float = movingBuffer.interpolate(moveProcess)
	enemy.position += moveToDir * speed * delta * buffer


func turn_to(target_position, delta):
	# get the angel between enemy toward the target position
	var moveToRadius = faceDir.angle_to(target_position - enemy.position)

	if moveToRadius > angularMargin:
		enemy.rotation += angularSpeed * delta
	elif moveToRadius < -angularMargin:
		enemy.rotation -= angularSpeed * delta
	else:
		faceDir = (target_position - enemy.position).normalized()
	# turn if the rotation of the enemy is smaller than the target position
#	if moveToRadius - enemy.rotation > angularMargin:
#		enemy.rotation_degrees += angularSpeed * delta
		# reset to zero when rotate fully 
#		if enemy.rotation_degrees - 360 < 0.5:
#			enemy.rotation_degrees = 0
	

func check_on_target(target_position):
	var result : bool
	var distanceToTarget = (target_position - enemy.position).length()
	if distanceToTarget < distanceMargin:
		result = true
	else:
		result = false
	return result

