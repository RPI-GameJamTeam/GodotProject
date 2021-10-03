extends Control

# this is the hud control node
export var health_reduction : int = 5
export var maxHealth : int = 100
var health

const AVATAR_LOCATION = {'air':"res://Asset/Avatar/air_ele.png", "ground":"res://Asset/Avatar/earth_ele.png",
						'fire':"res://Asset/Avatar/fire_ele.png", "water":"res://Asset/Avatar/water_ele.png"}



enum ElementState { PARTICLE, WATER, FIRE, AIR, GROUND }
signal health_run_out()

func _ready():
	health = maxHealth - 20
	$HealthBar.set_value((0.0 +health) / maxHealth * 100)
	
	onElementChanged(ElementState.PARTICLE)
	
	self.show()
	get_parent().get_parent().get_node("Shader/ColorRect").show()
	get_parent().get_parent().get_node("Player").connect("ElementTransition",self, "onElementChanged")
	
	healthDecay()

func healthDecay():
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	decreaseHP(health_reduction)
	healthDecay()

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

func decreaseHP(amount):
	health = max(health - amount, 0.0)
	$HealthBar.set_value(health / maxHealth * 100)
	
	if health == 0:
		get_parent().get_parent().get_node("Player").die()
