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
	if abs(walk) < player.WALK_FORCE * 0.2 or (velocity.x > 0 and player.input.x < 0) or (velocity.x < 0 and player.input.x > 0):
		velocity.x = move_toward(velocity.x, 0, player.STOP_FORCE * delta * 4)
	else:
		velocity.x += walk * delta * 1.5
		player.get_node("AnimatedSprite").play("run")
	
	if walk < 0:
		player.get_node("AnimatedSprite").scale.x = -1
	elif walk > 0:
		player.get_node("AnimatedSprite").scale.x = 1
	elif walk == 0 and get_parent().on_floor:
		player.get_node("AnimatedSprite").play("idle")
	
	if !get_parent().on_floor:
		if velocity.y < 0:
			player.get_node("AnimatedSprite").play("jump")
		else:
			player.get_node("AnimatedSprite").play("fall")
	
	# clamp velocity
	velocity.x = clamp(velocity.x, -player.WALK_MAX_SPEED * 1.5, player.WALK_MAX_SPEED * 1.5)

	# apply gravity
	velocity.y += player.gravity * 4 * delta * 2

	# move
	velocity = player.move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	if get_parent().on_floor and Input.is_action_just_pressed("jump"):
		velocity.y += -player.JUMP_SPEED
	
