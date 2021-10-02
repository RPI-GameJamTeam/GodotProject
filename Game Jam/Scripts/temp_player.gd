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

func _ready():
	spawnPos = position
	reset()

func reset():
	set_state(ElementState.PARTICLE)
	$AnimatedSprite.play("idle")
	position = spawnPos

func _process(delta):
	get_input()
	
	if Input.is_action_just_pressed("dash"):
		if state != ElementState.PARTICLE:
			dash()
			set_state(ElementState.PARTICLE)
		else:
			pass # leave chem trail

func dash():
	var dashRadius = 100
	position = position + input * dashRadius
	$Particles2D.restart()
	$Camera2D.add_trauma(0.4)
	$Camera2D.shake()

func set_state(s):
	state = s
	print(state)
	
	emit_signal("ElementTransition", s)
	
	get_node("StateMachine/Particle").is_active = false
	get_node("StateMachine/Water").is_active = false
	get_node("StateMachine/Fire").is_active = false
	get_node("StateMachine/Air").is_active = false
	get_node("StateMachine/Earth").is_active = false
	
	match state:
		ElementState.PARTICLE:
			get_node("StateMachine/Particle").is_active = true
		ElementState.WATER:
			get_node("StateMachine/Water").is_active = true
		ElementState.FIRE:
			get_node("StateMachine/Fire").is_active = true
		ElementState.AIR:
			get_node("StateMachine/Air").is_active = true
		ElementState.EARTH:
			get_node("StateMachine/Earth").is_active = true

func get_input():
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
	
	input = input.normalized()
