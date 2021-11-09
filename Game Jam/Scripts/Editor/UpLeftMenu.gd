extends Panel


onready var filePop = get_parent().get_node("FileDialog")
onready var level = get_parent().get_parent().get_node("Level")

var levelPath = "res://Level/"
var defaultName : String

func _ready():
#	filePop.current_file = "Level" + str(_get_default_level_index()) + ".tscn"
	filePop. set_filters(PoolStringArray(["*.tscn ; Level Files"]))
	defaultName = levelPath + "Level" + str(_get_default_level_index()) + ".tscn"


func _on_Save_pressed():
	filePop.current_file = defaultName
	filePop.mode = FileDialog.MODE_SAVE_FILE
	filePop.popup()


func _on_Load_pressed():
	filePop.current_dir = levelPath
	filePop.mode = FileDialog.MODE_OPEN_FILE
	filePop.popup()


func _get_default_level_index():
	var directory = Directory.new()
	var currenteIndex = 0
	while true:
		var file = levelPath + "Level" + str(currenteIndex) + ".tscn"

		if not directory.file_exists(file):
			break
		else:
			currenteIndex += 1

	return currenteIndex


func _on_FileDialog_confirmed():
	if filePop.mode == FileDialog.MODE_SAVE_FILE:
		var curScene = PackedScene.new()
		var result = curScene.pack(level)
		
		if result == OK:
			var error = ResourceSaver.save(filePop.current_file, curScene)
			
			if error != OK:
				push_error("An error oucur when saving the file to the disc")

	elif filePop.mode == FileDialog.MODE_OPEN_FILE:
		var curScene = load(filePop.current_path)
		level.queue_free()
		get_tree().current_scene.add_child(curScene.instance())
		


