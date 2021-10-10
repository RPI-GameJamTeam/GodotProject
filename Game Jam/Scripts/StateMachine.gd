extends Node2D

var on_floor : bool = false
var right_contact : bool = false
var left_contact : bool = false
var top_contact : bool = false
var clipping : bool = false

var grounded
var groundedLeft
var groundedRight

var groundedLastFrame
var groundedLeftLastFrame
var groundedRightLastFrame

var velocity : Vector2

func _ready():
	process_priority = 10

func _physics_process(_delta):
	groundedLastFrame = grounded
	groundedLeftLastFrame = groundedLeft
	groundedRightLastFrame = groundedRight
	
	grounded = get_parent().get_node("DownCast").is_colliding()
	groundedLeft = get_parent().get_node("DownLeftCast").is_colliding()
	groundedRight = get_parent().get_node("DownRightCast").is_colliding()
	
	clipping_fixer()
	
func clipping_fixer():
	if clipping:
		# this fucntion only fix clipping to right head wall
		# to compelte the fucntion need the head_up direction for the player
		get_parent().position.x += 0.5


func _on_Top_body_entered(_body):
	top_contact = true

func _on_Buttom_body_entered(_body):
	on_floor = true

func _on_Right_body_entered(_body):
	right_contact = true

func _on_Left_body_entered(_body):
	left_contact = true
	
func _on_Top_body_exited(_body):
	top_contact = false

func _on_Buttom_body_exited(_body):
	on_floor = false
	
func _on_Right_body_exited(_body):
	right_contact = false

func _on_Left_body_exited(_body):
	left_contact = false

func _on_Inner_body_entered(_body):
	clipping = true
	print('Not good Im inside the wall!')

func _on_Inner_body_exited(_body):
	clipping = false
	print('Im outside the wall, yeah!')
