extends Node


export var level_index : int = 1
export var developer_mode : bool = false

var current_level_index
var cookie_count

func _ready():
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/ColorRect/CanvasModulate.color = Color(0, 0, 0, 1)
	level_changer(level_index)
	
func _process(_delta):	
	if Input.is_action_pressed("ui_cancel"):
		pass#get_tree().quit()
	elif Input.is_action_pressed("restart"):
		get_tree().get_nodes_in_group("Player")[0].die()
		
func level_changer(index_value):
	current_level_index = index_value
	var list = get_tree().get_nodes_in_group("Level")
	if list.size() == 0:
		load_level_file()
	else:
		list[0].connect("tree_exited", self, "load_level_file")	
		for l in list:
			l.queue_free()

func next_level():
	level_changer(current_level_index+1)
	
func reset_level():
	current_level_index -= 1
	$CanvasLayer/AnimationPlayer.play("fade_to_black")
	
func reset_game():
	current_level_index = 0
	$CanvasLayer/AnimationPlayer.play("fade_to_black")

func load_level_file():
	# try to load next level by +1 to level index
	var temp = load("res://Level/Level"+str(current_level_index)+".tscn")
	# if next level not existed, load the win screen for the end of the game
	if temp == null:
		var credits = load("res://UI/WinScreen.tscn").instance()
		self.add_child(credits)
	# if next level existed, load the next level
	else:
		var Level = temp.instance()
		self.add_child(Level)
		_get_cookie_count()
	$CanvasLayer/AnimationPlayer.play("fade_from_black")

func kill_cookie():
	# called by other script to reduce cookie number
	cookie_count -= 1
	if cookie_count == 0:
		$CanvasLayer/AnimationPlayer.play("fade_to_black")

func _get_cookie_count():
	# update the max cookies number when level started
	cookie_count = 0
	for p in get_tree().get_nodes_in_group("PickUp"):
		if p.type == 4:
			cookie_count += 1

func _on_AnimationPlayer_animation_finished(anim_name):
	# change level when fade away animation finished
	if anim_name == "fade_to_black":
		next_level()

