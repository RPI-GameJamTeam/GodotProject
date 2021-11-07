extends Panel

enum tabs{Tiles, Misc, Obs, Picks}
var resDic : Dictionary
var curTab
# important
var rawPanel = load("res://Scenes/BuildIn/Panel.tscn")

# important
var dirPath = "res://Scenes/"

# test
onready var temp_tile = get_parent().get_parent().get_node("Level/TileMap")
onready var tem_sprite = get_parent().get_parent().get_node("Level/Grate")

func _load_resource() -> Dictionary:
	var dic = {"Misc":[], "Obs":[], "Picks":[], "Tiles":[]}
	for fileName in dic:
		var path = dirPath + fileName + "/"
		var items = GlobalTool.list_files_in_directory(path)
		for i in items:
			dic[fileName].append(path+i)

	return dic

func _add_panel(textureV, rectV) -> void:
	var panel = rawPanel.instance()
	# if is not tilemap
	if rectV == null:
		panel.get_child(0).texture = textureV
		$ScrollContainer/HBoxContainer.add_child(panel)

	else:
		panel.get_child(0).texture = textureV
		panel.get_child(0).region_rect = rectV
		panel.get_child(0).region_enabled = true
		$ScrollContainer/HBoxContainer.add_child(panel)


func _menu_update(fileDic) -> void:
	match curTab:
		tabs.Tiles:
			for tilePath in fileDic["Tiles"]:
				var tile = load(tilePath).instance()
				var data = _texture_taker(tile)
				_add_panel(data[0],data[1])
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
		cutReagion = Rect2(Vector2.ZERO, target.cell_size)

	elif target is KinematicBody2D:
		# player
		for child in target.get_children():
			if child is AnimatedSprite:
				finalTexture = child.frames.get_frame("idle", 0)
				break
			if child is Sprite:
				finalTexture = child.texture
				break

	elif target is Node2D:
		# the enemy, elevator, grate
		for child in target.get_child(0).get_children():
			if child is AnimatedSprite:
				finalTexture = child.frames.get_frame("idle", 0)
				break
			if child is Sprite:
				finalTexture = child.texture
				break

	return [finalTexture, cutReagion]

func _ready():
	resDic = _load_resource()
	_menu_update(resDic)
	# testing below



func _on_Tiles_pressed():
	curTab = tabs.Tiles
	_menu_update(resDic)


func _on_Misc_pressed():
	curTab = tabs.Misc
	_menu_update(resDic)


func _on_Obs_pressed():
	curTab = tabs.Obs
	_menu_update(resDic)

func _on_Picks_pressed():
	curTab = tabs.Picks
	_menu_update(resDic)
