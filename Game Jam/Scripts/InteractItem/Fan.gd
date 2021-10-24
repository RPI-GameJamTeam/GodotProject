tool
extends Node2D

export(Rect2) var region
export(Color) var rectColor
export(int) var windPower

var finalRect : Rect2 
	
onready var area = $Area2D

func _process(delta):
	# draw the affecting region for the wind
	if Engine.editor_hint:
		finalRect.size = region.size
		finalRect.position = -region.size
		finalRect.position.x = finalRect.position.x/2
		update()
		set_collision()
		


func set_collision():
	#set up shape
	var shape = $Area2D/CollisionShape2D.get_shape()
	shape.extents = region.size/2
	$Area2D/CollisionShape2D.set_shape(shape)
	
	#set up position 
	$Area2D/CollisionShape2D.position.y = -region.size.y/2
	pass
		
	
func _draw():
	# draw the region
	draw_rect(finalRect, rectColor, false, 1.0, false)

