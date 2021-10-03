extends Node

var current_level_index
export var Level_index : int = 1

var cookie_count

func _ready():
	$CanvasLayer/ColorRect/CanvasModulate.color = Color(0, 0, 0, 1)
	level_changer(Level_index)
	
func _process(delta):	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("restart"):
		get_tree().get_nodes_in_group("Player")[0].die()
		
func level_changer(level_index):
	current_level_index = level_index
	var list = get_tree().get_nodes_in_group("Level")
	if list.size() == 0:
		loadLevelFile()
	else:
		list[0].connect("tree_exited", self, "loadLevelFile")	
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

func loadLevelFile():
	var temp = load("res://Level/level"+str(current_level_index)+".tscn")
	if temp == null:
		var credits = load("res://UI/TitleScreen/WinScreen.tscn").instance()
		self.add_child(credits)
	else:
		var Level = temp.instance()
		self.add_child(Level)
		get_cookie_count()
	$CanvasLayer/AnimationPlayer.play("fade_from_black")

func kill_cookie():
	cookie_count -= 1
	if cookie_count == 0:
		$CanvasLayer/AnimationPlayer.play("fade_to_black")

func get_cookie_count():
	cookie_count = 0
	for p in get_tree().get_nodes_in_group("PickUp"):
		if p.type == 4:
			cookie_count += 1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		next_level()

