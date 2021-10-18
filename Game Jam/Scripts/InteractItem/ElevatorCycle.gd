extends PathFollow2D


export var moveing_speed = 100

var prevPos

func _ready():
	if $Elevator != null:
		prevPos = $Elevator.global_position

func _process(delta):
	if $Elevator != null:
		var currentPos = $Elevator.global_position
		set_offset(get_offset() + moveing_speed * delta)
		
		var dir = currentPos.x - prevPos.x
		
		prevPos = currentPos
