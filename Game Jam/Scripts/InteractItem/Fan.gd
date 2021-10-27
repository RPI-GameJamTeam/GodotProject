tool
extends Node2D

enum ElementState { PARTICLE, WATER, FIRE, AIR, EARTH }

export(Rect2) var region
export(Color) var rectColor
export(Vector2) var windPower

var up_dir = Vector2(0, -1)
var active : bool = false
var player : KinematicBody2D
var finalRect : Rect2

onready var area = $Area2D



func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	set_collision()


func _process(delta):
	# draw the affecting region for the editor only
	if Engine.editor_hint:
		finalRect.size = region.size
		finalRect.position = -region.size
		finalRect.position.x = finalRect.position.x/2
		update()

	if !Engine.editor_hint:
		up_dir = Vector2.UP.rotated(self.rotation)
		if active:
			if player.state == ElementState.AIR:
				player.get_node("StateMachine").velocity += windPower.length()* up_dir * delta


func set_collision():
	# set up shape
	var shape = $Area2D/CollisionShape2D.get_shape()
	shape.extents = region.size/2
	$Area2D/CollisionShape2D.set_shape(shape)

	# set up position
	$Area2D/CollisionShape2D.position.y = -region.size.y/2
	pass


func _draw():
	# draw the region
	draw_rect(finalRect, rectColor, false, 1.0, false)


func _on_Area2D_body_entered(body):
	active = true
	player.get_node("StateMachine/Air").fan_velocity = windPower.length()* up_dir


func _on_Area2D_body_exited(body):
	player.get_node("StateMachine/Air").fan_velocity = Vector2.ZERO
	active = false
