extends PathFollow2D


export var moveing_speed = 100

var prevPos

func _ready():
	if $Enemy != null:
		prevPos = $Enemy.global_position

func _process(delta):
	if $Enemy != null:
		var currentPos = $Enemy.global_position
		set_offset(get_offset() + moveing_speed * delta)
		
		var dir = currentPos.x - prevPos.x
		
		if dir < 0:
			$Enemy/AnimatedSprite.set_flip_v(true)
		else:
			$Enemy/AnimatedSprite.set_flip_v(false)
		
		print(currentPos.x - prevPos.x)
		prevPos = currentPos
