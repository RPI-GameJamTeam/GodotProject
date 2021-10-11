extends KinematicBody2D

enum ElementState { PARTICLE, WATER, FIRE, AIR, EARTH }
var state

signal ElementTransition(value)

const WALK_FORCE = 450	
const WALK_MAX_SPEED = 200
const STOP_FORCE = 2600
const JUMP_SPEED = 400

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var input = Vector2()
var spawnPos = Vector2()
var dead = false

func _ready():
	spawnPos = position
	reset()

func reset():
	set_state(ElementState.PARTICLE)
	$AnimatedSprite.play("idle")
	position = spawnPos
	GlobalTool.set_all_glow(ElementState.PARTICLE)
	dead = false

func _process(_delta):
	get_input()
	
	if Input.is_action_just_pressed("dash"):
		if state != ElementState.PARTICLE:
			set_state(ElementState.PARTICLE)
			dash()

func dash():
	var dashRadius = 100
	var point = position + input * dashRadius
	var space_state = get_world_2d().direct_space_state
	var i = 0
	while space_state.intersect_point(point).size() > 0:
		point = position + (input * dashRadius * ((i * 5) / dashRadius))
		if i * 5 == dashRadius:
			break;
		i = i + 1
	
	position = point

	$Particles2D.restart()
	
	GlobalTool.set_all_glow(ElementState.PARTICLE)

#	$Camera2D.add_trauma(0.4)
#	$Camera2D.shake()

	for c in get_tree().get_nodes_in_group("Grate"):
		c.get_node("CollisionShape2D").set_deferred("disabled", false)

func set_state(s):
	state = s
	
	emit_signal("ElementTransition", s)
	
	get_node("StateMachine/Particle").is_active = false
	get_node("StateMachine/Water").is_active = false
	get_node("StateMachine/Fire").is_active = false
	get_node("StateMachine/Air").is_active = false
	get_node("StateMachine/Earth").is_active = false
	
	if state != ElementState.EARTH:
		rotation = 0
	
	match state:
		ElementState.PARTICLE:
			get_node("StateMachine/Particle").is_active = true
		ElementState.WATER:
			get_node("StateMachine/Water").is_active = true
			
			for c in get_tree().get_nodes_in_group("Grate"):
				c.get_node("CollisionShape2D").set_deferred("disabled", true)
		ElementState.FIRE:
			get_node("StateMachine/Fire").is_active = true
		ElementState.AIR:
			get_node("StateMachine/Air").is_active = true
		ElementState.EARTH:
			get_node("StateMachine/Earth").is_active = true

func get_input():
	if dead:
		return null

	if state != ElementState.FIRE:
		input = Vector2()
	
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("up"):
		input.y -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
		
	input.x = min(input.x, 1)
	input.x = max(input.x, -1)
	input.y = min(input.y, 1)
	input.y = max(input.y, -1)
	
	if state == ElementState.AIR:
		input = input.normalized()

func die():
	if dead:
		return null
	dead = true
	set_state(0)
	get_node("StateMachine/Particle").is_active = false
	
	input = Vector2(0, 0)
	GlobalTool.set_all_glow(ElementState.PARTICLE)
	
	$Particles2D.restart()
	$AnimatedSprite.play("death")
	get_tree().get_root().get_child(1).reset_level()



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		pass
