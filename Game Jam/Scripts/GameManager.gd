extends Node

var current_level_index
export var Level_index : int = 1

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("restart"):
		get_tree().get_nodes_in_group("Player")[0].die()
		
		
func level_changer(level_index):
	for l in get_tree().get_nodes_in_group("Level"):
		l.queue_free()
	
	current_level_index = level_index
	var Level = load("res://Level/level"+str(level_index)+".tscn").instance()
	self.add_child(Level)

func _ready():
	level_changer(Level_index)
