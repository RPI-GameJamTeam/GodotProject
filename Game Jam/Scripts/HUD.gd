extends Control

# this is the hud control node
export var health_reduction : int

enum ElementState { PARTICLE, WATER, FIRE, AIR, GROUND }
signal health_run_out()

func _ready():
	self.show()
	get_parent().get_parent().get_node("Player").connect("ElementTransition",self, "onElementChanged")

func onElementChanged(value):
	
	match value:
		ElementState.PARTICLE:
			pass
		ElementState.AIR:
			pass
		ElementState.FIRE:
			pass
		ElementState.GROUND:
			pass


