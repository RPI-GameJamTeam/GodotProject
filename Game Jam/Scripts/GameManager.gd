extends Node

var current_level_index
export var Level_index : int = 1

var cookie_count

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("restart"):
		get_tree().get_nodes_in_group("Player")[0].die()
		
		
func level_changer(level_index):
	current_level_index = level_index
	var list = get_tree().get_nodes_in_group("Level")
	if list.size() == 0:
		levelChange()
	else:
		list[0].connect("tree_exited", self, "levelChange")	
		for l in list:
			l.queue_free()

func levelChange():
	var Level = load("res://Level/level"+str(current_level_index)+".tscn").instance()
	self.add_child(Level)
	get_cookie_count()

func _ready():
	level_changer(Level_index)

func next_level():
	level_changer(current_level_index+1)
	
func kill_cookie():
	cookie_count -= 1
	if cookie_count == 0:
		next_level()

func get_cookie_count():
	cookie_count = 0
	for p in get_tree().get_nodes_in_group("PickUp"):
		if p.type == 4:
			cookie_count += 1
