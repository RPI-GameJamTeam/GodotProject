extends Node2D

var player

var is_active : bool = false

func _ready():
	player = get_parent().get_parent()

func _physics_process(delta):	
	if !is_active:
		return null
	
	get_parent().velocity = player.input.normalized() * 250
	
	player.get_node("AnimatedSprite").play("idle")
	
	# clamp velocity
	get_parent().velocity.x = clamp(get_parent().velocity.x, -player.WALK_MAX_SPEED, player.WALK_MAX_SPEED)
	get_parent().velocity.y = clamp(get_parent().velocity.y, -player.WALK_MAX_SPEED, player.WALK_MAX_SPEED)

	# move
	player.move_and_slide_with_snap(get_parent().velocity, Vector2.DOWN, Vector2.UP)
