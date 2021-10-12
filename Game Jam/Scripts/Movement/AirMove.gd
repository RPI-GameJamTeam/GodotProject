extends Node2D

var player

var is_active : bool = false
var charges
var slowDown = false
var canBounce = true

var bounceTimer = Timer.new()

func _ready():
	player = get_parent().get_parent()
	
	bounceTimer.set_wait_time(0.15)
	bounceTimer.set_one_shot(true)
	self.add_child(bounceTimer)
	bounceTimer.connect("timeout", self, "resetBounce")	
	
func _process(delta):
	if Input.is_action_pressed("air_slow"):
		slowDown = true
	else:
		slowDown = false

func _physics_process(delta):	
	if !is_active:
		return null
		
	get_parent().velocity += player.input * player.WALK_FORCE * delta * 0.25
	
	if slowDown:
		get_parent().velocity.x = move_toward(get_parent().velocity.x, 0, player.STOP_FORCE * delta / 50)
		get_parent().velocity.y = move_toward(get_parent().velocity.y, 0, player.STOP_FORCE * delta / 50)
	
	if get_parent().velocity.x < 0:
		player.get_node("AnimatedSprite").scale.x = -1
	elif get_parent().velocity.x > 0:
		player.get_node("AnimatedSprite").scale.x = 1
	elif get_parent().velocity.x == 0 and get_parent().velocity.y == 0:
		player.get_node("AnimatedSprite").play("idle")
	
	if !get_parent().on_floor:
		if get_parent().velocity.y < 0:
			player.get_node("AnimatedSprite").play("jump")
		else:
			player.get_node("AnimatedSprite").play("fall")
	
	# clamp velocity
	get_parent().velocity.x = clamp(get_parent().velocity.x, -player.WALK_MAX_SPEED*0.5, player.WALK_MAX_SPEED*0.5)
	get_parent().velocity.y = clamp(get_parent().velocity.y, -player.WALK_MAX_SPEED*0.5, player.WALK_MAX_SPEED*0.5)

	# move
	get_parent().velocity = player.move_and_slide(get_parent().velocity, Vector2.UP)
	
	for i in player.get_slide_count():
		if !canBounce:
			continue
		if !player.get_slide_collision(i).collider.is_in_group("PickUp"):
			canBounce = false
			bounceTimer.start()
			
			var bounceForce = 80
			var normal = player.get_slide_collision(i).normal
			get_parent().velocity += normal * bounceForce
			
			charges = charges - 1
			if charges == 0:
				player.set_state(player.ElementState.PARTICLE)
				player.transitionToParticle()
			else:
				player.get_node("Particles2D").restart()
			
			break

func resetBounce():
	canBounce = true
