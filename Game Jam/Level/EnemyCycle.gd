extends PathFollow2D


export var moveing_speed = 20

func _process(delta):
	set_offset(get_offset() + moveing_speed * delta)
