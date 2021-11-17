extends Panel

var objectType
var objectName


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				print(objectType)
				print(objectName)
				# debug dont delete until the menu selection is finished.
#				print(objectName)
#				print(objectType)
				set_cur_selection()
				
func set_cur_selection():
	var editor = get_tree().get_root().get_node("LevelEditor")
	
	# if the select object is tilemap
	if objectType == "TileMap":
		print('ha')
		editor.curTile = editor.level.get_node("Tiles/"+objectName)
		editor.cursor = editor.cursorMode.BRUSHING
	
	# if the select object is Misc
	elif objectType == "Misc":
		editor.placingInstance = load("res://Scenes/Misc/"+objectName+".tscn").instance()
		editor.cursor = editor.cursorMode.PLACING
		editor.placingType = "Misc"


