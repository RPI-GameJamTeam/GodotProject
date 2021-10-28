tool
extends Node2D

export(int) var speed = 1
export(float) var distanceMargin = 0.5
export(PoolVector2Array) var targetPoints
export(Curve) var movingBuffer
export(Vector2) var scale_for_sprite

var targetPointIndex = 0
var originalPosition : Vector2

onready var elevator = $KinematicBody2D

func _ready():
	if !targetPoints[0] == Vector2.ZERO:
		targetPoints.insert(0, Vector2.ZERO)
	originalPosition = elevator.position
	elevator.scale = scale_for_sprite

func _physics_process(delta):

	move_to(targetPoints[targetPointIndex], delta)
	if check_on_target(targetPoints[targetPointIndex]):
		
		if targetPoints.size() > targetPointIndex + 1:
			originalPosition = targetPoints[targetPointIndex]
			targetPointIndex += 1
		else:
			originalPosition = targetPoints[targetPointIndex]
			targetPointIndex = 0

func move_to(target_position, delta):
	var moveToDir : Vector2 = (target_position - elevator.position).normalized()
	var moveProcess = abs((elevator.position - originalPosition).length()/(target_position - originalPosition).length()) if (target_position - originalPosition).length() !=0 else 1
	var buffer : float = movingBuffer.interpolate(moveProcess)
	elevator.position += moveToDir * speed * delta * buffer


func check_on_target(target_position):
	var result : bool
	var distanceToTarget = (target_position - elevator.position).length()
	if distanceToTarget < distanceMargin:
		result = true
	else:
		result = false
	return result
