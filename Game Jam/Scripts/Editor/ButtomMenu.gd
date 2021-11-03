extends Panel

enum tabs{Tiles, Misc, Obs, Picks}
var resDic : Dictionary
var curTab

onready var temp_tile = get_parent().get_parent().get_node("Level/TileMap")

func _load_resource() -> Dictionary:
	var dirPath = "res://Scenes/"
	var dic = {"Misc":[], "Obs":[], "Picks":[], "Tiles":[]}
	
	var directory = Directory.new()
	
	for fileName in dic:
		var path = dirPath + fileName + "/"
		var items = GlobalTool.list_files_in_directory(path)
		dic[fileName] = items
		
	return dic

func _add_panel(texture) -> void:
	pass

func _menu_update() -> void:
	match curTab:
		tabs.Tiles:
			pass
		tabs.Misc:
			pass
		tabs.Obs:
			pass
		tabs.Picks:
			pass
			
func _texture_taker(target):
	var finalTexture : Texture
	var cutReagion : Rect2
	if target is TileMap:
		var tileSet : TileSet = target.tile_set
		finalTexture = tileSet.tile_get_texture(0)
		cutReagion = tileSet.tile_get_region(0)
		
	if target is KinematicBody2D:
		# player
		pass
	if target is Node2D:
		# the enemy, elevator, grate
		pass
	return [finalTexture, cutReagion]
	
func _ready():
	resDic = _load_resource()
	_menu_update()
	# testing below
	var rawp = _texture_taker(temp_tile)
	$TextureRect.texture = rawp[0]
	$TextureRect.region_rect = rawp[1]
	$TextureRect.region_enabled = true
	


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
