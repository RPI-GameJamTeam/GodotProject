extends KinematicBody2D

var state
enum ELESTATE{WATER, FIRE, AIR, GROUND, DEFAULT}
func _ready():
	state = ELESTATE.DEFAULT

func _process(delta):
	match state:
		ELESTATE.DEFAULT:
			get_node("StateMachine/Default").is_active = true
			


func _on_Right_body_exited(body):
	pass # Replace with function body.
