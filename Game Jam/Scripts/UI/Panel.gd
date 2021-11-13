extends Panel

var objectType
var objectName


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				# debug dont delete until the menu selection is finished.
#				print(objectName)
#				print(objectType)
				set_cur_selection()
				
func set_cur_selection():
	var editor = get_tree().get_root().get_node("LevelEditor")
	
	# if the select object is tilemap
	if objectType == "TileMap":
		editor.curTile = editor.level.get_node("TileGroup/"+objectName)
		editor.cursor = editor.cursorMode.BRUSHING
	
	# if the select object is enemy
	
	# if the select object is obstacle
	
	# if the select obejct is decoration
	
	# if the select obejct is player
