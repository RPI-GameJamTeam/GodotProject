extends Panel

enum tabs{TILES, MISC, MOBS}
var objectPathDic : Dictionary	#dic that
var defaultTab = tabs.TILES
var curTab = defaultTab
# important, delete will cause loading problem, change path will cause loading problem
var rawPanel = load("res://Scenes/BuildIn/Panel.tscn")


# clear all the panel in the tab
func clear_panel() -> void:
	for p in $ScrollContainer/HBoxContainer.get_children():
		p.queue_free()


# add one panel with given texture, if is tilemap ,rectV is required, other use Rect()
func add_panel(textureV, rectV, nameV, typeV) -> void:
	var panel = rawPanel.instance()
	# if is not tilemap
	if rectV == Rect2():
		panel.get_child(0).texture = textureV
		panel.objectType = typeV
		panel.objectName = nameV
		$ScrollContainer/HBoxContainer.add_child(panel)
		
	# if it is tilemap
	else:
		panel.get_child(0).texture = textureV
		panel.get_child(0).region_rect = rectV
		panel.get_child(0).region_enabled = true
		panel.objectType = "TileMap"
		panel.objectName = nameV
		$ScrollContainer/HBoxContainer.add_child(panel)
		


# update the menu based on the list
func menu_update(fileDic) -> void:
	clear_panel()
	var tabName
	match curTab:
		tabs.TILES:
			tabName = "Tiles"
		tabs.MISC:
			tabName = "Misc"
		tabs.MOBS:
			tabName = "Mobs"

	for path in fileDic[tabName]:
		var object = load(path).instance()
		var data = get_object_texture(object)
		print(object.name)
		add_panel(data[0], data[1], object.name, tabName)


# get texture from all kinds of object
func get_object_texture(target):
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

	elif target is Area2D:
		# all the pickups
		for child in target.get_children():
			if child is AnimatedSprite:
				finalTexture = child.frames.get_frame(child.animation, 0)
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


# get the all object path to dictionary then update the menu to default tab
func _ready():
	objectPathDic = GlobalTool.load_resource_path()
	menu_update(objectPathDic)


# below are button signals, connect tab button to the curTab variable
func _on_Tiles_pressed():
	curTab = tabs.TILES
	menu_update(objectPathDic)


func _on_Misc_pressed():
	curTab = tabs.MISC
	menu_update(objectPathDic)


func _on_Mobs_pressed():
	curTab = tabs.MOBS
	menu_update(objectPathDic)
	
func _on_Picks_pressed():
	curTab = tabs.Picks
	menu_update(objectPathDic)

# cancle focus when click on other object, important dont delete
func _unhandled_input(event):
	var current_focus_control = get_focus_owner()
	if current_focus_control:
		current_focus_control.release_focus()
