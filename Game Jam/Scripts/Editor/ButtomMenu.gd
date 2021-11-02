extends Panel

enum tabs{Tiles, Misc, Obs, Picks}
var resDic : Dictionary
var curTab

func _load_resource() -> Dictionary:
	var dirPath = "res://Scenes/"
	var dic = {"Misc":[], "Obs":[], "Picks":[], "Tiles":[]}
	
	var directory = Directory.new()
	
	for fileName in dic:
		var path = dirPath + fileName + "/"
		var items = GlobalTool.list_files_in_directory(path)
		dic[fileName] = items
		
	return dic

func _menu_update() -> void:
	pass
	
func _ready():
	resDic = _load_resource()
	_menu_update()


func _on_Tiles_pressed():
	curTab = tabs.Tiles
	_menu_update()


func _on_Misc_pressed():
	curTab = tabs.Misc
	_menu_update()


func _on_Obs_pressed():
	curTab = tabs.Obs
	_menu_update()

func _on_Picks_pressed():
	curTab = tabs.Picks
	_menu_update()
