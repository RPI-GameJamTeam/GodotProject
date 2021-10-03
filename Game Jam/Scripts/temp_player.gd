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

func _process(delta):
	get_input()
	
	if position.y > 100:
		die()
	
	if Input.is_action_just_pressed("dash"):
		if state != ElementState.PARTICLE:
			dash()
			set_state(ElementState.PARTICLE)

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
	
	get_tree().get_nodes_in_group("Vignette")[0].material.set_shader_param("color", Color(0,0,0))
	$AnimatedSprite.material.set_shader_param("glow_color", Color(0,0,0))
	
	$Camera2D.add_trauma(0.4)
	$Camera2D.shake()

func set_state(s):
	state = s
	
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
	
	if state == ElementState.AIR:
		input = input.normalized()

func die():
	if dead:
		return null
	dead = true
	set_state(0)
	get_node("StateMachine/Particle").is_active = false
	
	input = Vector2(0, 0)
	get_tree().get_nodes_in_group("Vignette")[0].material.set_shader_param("color", Color(0,0,0))
	$AnimatedSprite.material.set_shader_param("glow_color", Color(0,0,0))
	
	$Particles2D.restart()
	$AnimatedSprite.connect("animation_finished", self, "resetGame")
	$AnimatedSprite.play("death")
		

func resetGame():
	print("hello")
	get_tree().reload_current_scene()
