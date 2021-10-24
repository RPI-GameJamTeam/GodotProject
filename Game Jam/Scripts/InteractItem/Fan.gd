tool
extends Node2D

export(Rect2) var region
export(Color) var rectColor
export(int) var windPower

var finalRect : Rect2 
var extend : Vector2
	
onready var area = $Area2D

func _process(delta):
	# draw the affecting region for the wind
	if Engine.editor_hint:
		finalRect.size = region.size
		finalRect.position = -region.size
		finalRect.position.x = finalRect.position.x/2
		update()

		
	
func _draw():
	# draw the region
	draw_rect(finalRect, rectColor, false, 1.0, false)

