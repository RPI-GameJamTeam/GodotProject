extends Node2D

var player

var is_active : bool = false

var velocity : Vector2

var localGrounded
var localWasGrounded

var tilemap
var tileSize
var tilePos
var tileIndex

func _ready():
	player = get_parent().get_parent()	
	tilemap = get_tree().get_nodes_in_group("Tilemap")[0]
	var tile_rect = tilemap.get_used_rect()
	tileSize = tilemap.map_to_world(tile_rect.size)

func _physics_process(delta):
#	var test = load("res://Scenes/DebugCircle.tscn").instance()
#	player.get_parent().add_child(test)
#	test.global_position = player.global_position
	
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
	var leftGrounded = player.get_node("DownLeftCast").is_colliding()
	var rightGrounded = player.get_node("DownRightCast").is_colliding()
	
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
	elif movement.x == 0 and localGrounded or rightGrounded or leftGrounded:
		player.get_node("AnimatedSprite").play("idle")
	
	if !localGrounded and !rightGrounded and !leftGrounded:
		if velocity.y < 0:
			player.get_node("AnimatedSprite").play("jump")
		else:
			player.get_node("AnimatedSprite").play("fall")
	
	# clamp velocity
	velocity.x = clamp(velocity.x, -player.WALK_MAX_SPEED, player.WALK_MAX_SPEED)

	# move
	velocity = player.move_and_slide_with_snap(velocity.rotated(player.rotation), Vector2.DOWN, Vector2.UP).rotated(-player.rotation)
	velocity.x = round(velocity.x)
	velocity.y = round(velocity.y)
	
	var newTilePos = tilemap.world_to_map(player.position + (player.get_node("DownCast").cast_to + Vector2(0, 10)).rotated(player.rotation))
	var newTileIndex = tilemap.get_cellv(newTilePos)
	
	var nearest90 = int(rad2deg(round(player.rotation / deg2rad(45)) * deg2rad(45)))
	if newTileIndex == -1 and tileIndex != -1 and nearest90 != -180 and nearest90 != 180:
		# get the center of the tile in world coords
		print(tilePos)
		print(tilemap.map_to_world(tilePos))
		var tileWorldPos = tilemap.map_to_world(tilePos) + Vector2(16, 16) # 32x32 tiles, so 16 give us center
		var distance_from_point = player.global_position - tileWorldPos
		
		var phi = atan2(distance_from_point.y, distance_from_point.x)
		var nearest45 = round(phi / deg2rad(45)) * deg2rad(45);
		phi = phi - nearest45
		var theta = phi
		var rotationAngle = -2*theta
		
		var rotated = false
		
		if leftGrounded and !rightGrounded: # rotate clockwise
			var xNew = distance_from_point.x * cos(rotationAngle) - distance_from_point.y * sin(rotationAngle)
			var yNew = distance_from_point.x * sin(rotationAngle) + distance_from_point.y * cos(rotationAngle)
			
			player.global_position = Vector2(tileWorldPos + Vector2(xNew, yNew))
			player.rotation += deg2rad(90)
			
			rotated = true
		elif !leftGrounded and rightGrounded: # rotate counterclockwise			
			var xNew = distance_from_point.x * cos(rotationAngle) - distance_from_point.y * sin(rotationAngle)
			var yNew = distance_from_point.x * sin(rotationAngle) + distance_from_point.y * cos(rotationAngle)
			
			player.global_position = Vector2(tileWorldPos + Vector2(xNew, yNew))
			player.rotation += deg2rad(-90)
			
			rotated = true
		
		if rotated:
			velocity.x = 0
			velocity.y = 0
	else:
		if !localGrounded and !attemptedRotation and !leftGrounded and !rightGrounded:
			player.rotation = 0
			velocity.y += player.gravity * 4 * delta * 2
	
	tilePos = newTilePos
	tileIndex = newTileIndex


	if localGrounded and Input.is_action_just_pressed("jump"):
		velocity.y += -player.JUMP_SPEED

