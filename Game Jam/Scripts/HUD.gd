extends Control

# this is the hud control node
export var health_reduction : int = 5
export var maxHealth : int = 100
var health
var player


const AVATAR_LOCATION = {'air':"res://Asset/Art/Avatar/air_ele.png", "earth":"res://Asset/Art/Avatar/earth_ele.png",
						'fire':"res://Asset/Art/Avatar/fire_ele.png", "water":"res://Asset/Art/Avatar/water_ele.png"}



enum ElementState { PARTICLE, WATER, FIRE, AIR, EARTH }

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	health = maxHealth - 20
	$HealthBar.set_value((0.0 +health) / maxHealth * 100)
	
	onElementChanged(ElementState.PARTICLE)
	
	self.show()
	get_parent().get_parent().get_node("Shader/ColorRect").show()
	player.connect("ElementTransition",self, "onElementChanged")
	
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
		ElementState.EARTH:
			$frame/avatar.set_texture(load(AVATAR_LOCATION['earth']))
		ElementState.WATER:
			$frame/avatar.set_texture(load(AVATAR_LOCATION['water']))

func decreaseHP(amount):
	health = max(health - amount, 0.0)
	$HealthBar.set_value(health / maxHealth * 100)
	
	if health == 0:
		player.die()

func increaseHP(amount):
	health += amount
	$HealthBar.set_value(health / maxHealth * 100)
