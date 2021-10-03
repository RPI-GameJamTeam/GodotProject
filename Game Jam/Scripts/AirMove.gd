extends Node2D

var player

var is_active : bool = false

var velocity : Vector2

func _ready():
	player = get_parent().get_parent()

func _physics_process(delta):	
	if !is_active:
		return null
		
	velocity += player.input * player.WALK_FORCE * delta * 0.25
	
	if velocity.x < 0:
		player.get_node("AnimatedSprite").scale.x = -1
	elif velocity.x > 0:
		player.get_node("AnimatedSprite").scale.x = 1
	elif velocity.x == 0 and get_parent().on_floor:
		player.get_node("AnimatedSprite").play("idle")
	
	if !get_parent().on_floor:
		if velocity.y < 0:
			player.get_node("AnimatedSprite").play("jump")
		else:
			player.get_node("AnimatedSprite").play("fall")
	
	# clamp velocity
	velocity.x = clamp(velocity.x, -player.WALK_MAX_SPEED*0.5, player.WALK_MAX_SPEED*0.5)
	velocity.y = clamp(velocity.y, -player.WALK_MAX_SPEED*0.5, player.WALK_MAX_SPEED*0.5)

	# move
	velocity = player.move_and_slide(velocity, Vector2.UP)
	
	for i in player.get_slide_count():
		if !player.get_slide_collision(i).collider.is_in_group("PickUp"):
			player.reset()
