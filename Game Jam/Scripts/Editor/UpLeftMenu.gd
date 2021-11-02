extends Panel
 

onready var filePop = get_parent().get_node("FileDialog")
var levelPath = "res://Level/"
var defaultName : String

func _ready():
	filePop.current_file = "Level" + str(_get_default_level_index()) + ".tscn"
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
	var directory = Directory.new();
	var currenteIndex = 0
	while true and currenteIndex < 20:
		var file = levelPath + "Level" + str(currenteIndex) + ".tscn"

		if not directory.file_exists(file):
			break
		else:
			currenteIndex += 1

	return currenteIndex


func _on_FileDialog_confirmed():
	print('ha')
