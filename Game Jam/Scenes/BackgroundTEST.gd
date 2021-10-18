extends ParallaxBackground


func _ready():

	for c in get_children():
		print(c.get_light_mask())
	
