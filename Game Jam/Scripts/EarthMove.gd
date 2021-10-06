extends Node2D

var player

var is_active : bool = false

var velocity : Vector2

var localGrounded
var localWasGrounded

func _ready():
	player = get_parent().get_parent()

func _physics_process(delta):	
	if !is_active:
		return null
	
	var attemptedRotation = false
	if player.input.x > 0 and get_parent().right_contact: # jump to right wall
		player.rotation += deg2rad(-90)
		attemptedRotation = true
	if player.input.x < 0 and get_parent().left_contact: # jump to left wall
		player.rotation += deg2rad(90)
		attemptedRotation = true

	var movement = Vector2((player.input * player.WALK_FORCE).x, 0)
	localWasGrounded = localGrounded
	localGrounded = player.get_node("DownCast").is_colliding()
	
	# slow the player down while not moving
	var cond1 = abs(movement.x) < player.WALK_FORCE * 0.2
	var cond2 = velocity.x > 0 and player.input.x < 0
	var cond3 = velocity.x < 0 and player.input.x > 0
	if cond1 or cond2 or cond3:
		velocity.x = move_toward(velocity.x, 0, player.STOP_FORCE * delta * 4)
	else:
		velocity += movement * delta 
		player.get_node("AnimatedSprite").play("run")
	
	if movement.x < 0:
		player.get_node("AnimatedSprite").scale.x = -1
	elif movement.x > 0:
		player.get_node("AnimatedSprite").scale.x = 1
	elif movement.x == 0 and localGrounded:
		player.get_node("AnimatedSprite").play("idle")
	
	if !localGrounded:
		if velocity.y < 0:
			player.get_node("AnimatedSprite").play("jump")
		else:
			player.get_node("AnimatedSprite").play("fall")
	
	# clamp velocity
	velocity.x = clamp(velocity.x, -player.WALK_MAX_SPEED, player.WALK_MAX_SPEED)

	# apply gravity
	if (!localGrounded) and !attemptedRotation:
		if !localWasGrounded:
			pass
			#player.rotation = 0
			#velocity.y += player.gravity * 4 * delta * 2
		else:
			var leftGrounded = player.get_node("DownLeftCast").is_colliding()
			var rightGrounded = player.get_node("DownRightCast").is_colliding()
			
			if leftGrounded and !rightGrounded: # rotate clockwise
				player.rotation += deg2rad(90)
			elif !leftGrounded and rightGrounded: # rotate counterclockwise
				player.rotation += deg2rad(-90)
			else:
				print("fall")

	# move
	velocity = player.move_and_slide_with_snap(velocity.rotated(player.rotation), Vector2.DOWN, Vector2.UP).rotated(-player.rotation)
	velocity.x = round(velocity.x)
	velocity.y = round(velocity.y)

	if localGrounded and Input.is_action_just_pressed("jump"):
		velocity.y += -player.JUMP_SPEED
	
