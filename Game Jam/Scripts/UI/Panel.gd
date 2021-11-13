extends Panel

var objectType
var objectName


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				print(objectName)
				print(objectType)
				set_cur_selection()
				
func set_cur_selection():
	var editor = get_tree().get_root().get_node("LevelEditor")
	
	if objectType == "TileMap":
		editor.curTile = editor.get_node("Level/TileGroup/"+objectName)
		editor.cursor = editor.cursorMode.BRUSHING
