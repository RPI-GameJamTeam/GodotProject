extends KinematicBody2D

export(int) var speed = 1

func _physics_process(delta):
	position.y -= delta * speed
