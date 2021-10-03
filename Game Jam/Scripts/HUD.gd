extends Control

# this is the hud control node
export var health_reduction : int
const AVATAR_LOCATION = {'air':"res://Asset/Avatar/air_ele.png", "ground":"res://Asset/Avatar/earth_ele.png",
						'fire':"res://Asset/Avatar/fire_ele.png", "water":"res://Asset/Avatar/water_ele.png"}



enum ElementState { PARTICLE, WATER, FIRE, AIR, GROUND }
signal health_run_out()

func _ready():
	self.show()
	get_parent().get_parent().get_node("Shader/ColorRect").show()
	get_parent().get_parent().get_node("Player").connect("ElementTransition",self, "onElementChanged")
	
func onElementChanged(value):

	match value:
		ElementState.PARTICLE:
			$frame/avatar.set_texture(null)
		ElementState.AIR:
			$frame/avatar.set_texture(load(AVATAR_LOCATION['air']))
		ElementState.FIRE:
			$frame/avatar.set_texture(load(AVATAR_LOCATION['fire']))
		ElementState.GROUND:
			$frame/avatar.set_texture(load(AVATAR_LOCATION['ground']))
		ElementState.WATER:
			$frame/avatar.set_texture(load(AVATAR_LOCATION['water']))


