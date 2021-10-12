extends Node2D

var player

var is_active : bool = false

var velocity : Vector2

func _ready():
	player = get_parent().get_parent()

func _physics_process(delta):	
	if !is_active:
		return null
		
	var walk = player.input.x * player.WALK_FORCE
	
	# slow the player down while not moving
	if abs(walk) < player.WALK_FORCE * 0.2 or (get_parent().velocity.x > 0 and player.input.x < 0) or (get_parent().velocity.x < 0 and player.input.x > 0):
		get_parent().velocity.x = move_toward(get_parent().velocity.x, 0, player.STOP_FORCE * delta * 4)
	else:
		get_parent().velocity.x += walk * delta 
		player.get_node("AnimatedSprite").play("run")
	
	if walk < 0:
		player.get_node("AnimatedSprite").scale.x = -1
	elif walk > 0:
		player.get_node("AnimatedSprite").scale.x = 1
	elif walk == 0 and get_parent().grounded:
		player.get_node("AnimatedSprite").play("idle")
	
	if !get_parent().grounded:
		if get_parent().velocity.y < 0:
			player.get_node("AnimatedSprite").play("jump")
		else:
			player.get_node("AnimatedSprite").play("fall")
	
	# clamp velocity
	get_parent().velocity.x = clamp(get_parent().velocity.x, -player.WALK_MAX_SPEED, player.WALK_MAX_SPEED)

	# apply gravity
	get_parent().velocity.y += player.gravity * 4 * delta * 2

	# move
	get_parent().velocity = player.move_and_slide_with_snap(get_parent().velocity, Vector2.DOWN, Vector2.UP)	
