extends Node2D

# tools we need
# brush for the tile
# load asset to the menu
# move tool
# delete tool
# select tool

# different mode
enum viewportMode {FOLLOW, IDLE}
enum cursorMode {DELETE, PLACING, SELECT, MOVING, BRUSHING}

# editor variable
var level

# viewport control
var view = viewportMode.IDLE
var mouseOrgPosition : Vector2
var cameraOrgPosition : Vector2
var zoomStep = Vector2(0.1, 0.1)

# tool general variable
var cursor = cursorMode.SELECT
var left_pressing : bool = false

# item placing 
var placingInstance
var placingType
var selectedList = []
var couldPlace : bool

# tilemap brush
var brushSize = Vector2(1, 1)
var curTile
var couldDraw : bool
var couldErase : bool

onready var camera = $Camera2D


# brush tool
func brushing(tileIndex):
	if curTile != null:
		var cellSize = curTile.cell_size
		curTile.set_cellv(curTile.world_to_map(get_global_mouse_position()), tileIndex)
		curTile.update_bitmask_area(curTile.world_to_map(get_global_mouse_position()))
		



# add total 5 group for different object types
func add_node_group()-> void:
	var groups = ['Tiles', "Misc",
				  'Mobs']

	for group in groups:
		var newGroup = Node2D.new()
		newGroup.name = group
		level.add_child(newGroup)
		newGroup.owner = level
		
		if group == "Tiles":
			add_all_tilemap()


# add all tilemap to the Tiles
func add_all_tilemap() -> void:
	var pathDir = GlobalTool.load_resource_path()
	for tilePath in pathDir["Tiles"]:
		var tile = load(tilePath).instance()
		level.get_node("Tiles").add_child(tile)
		tile.owner = level


func _ready():
	level = get_tree().get_nodes_in_group("level")[0]
	add_node_group()

func _unhandled_input(event):
	# screen control
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_DOWN:
				# zoom step = 0.1 zoom down
				camera.zoom += zoomStep

			if event.button_index == BUTTON_WHEEL_UP:
				# zoom step = 0.1 zoom up
				camera.zoom -= zoomStep

			if event.button_index == BUTTON_MIDDLE:
				# recording the ori position for cursor and camera, then make it move in _process
				mouseOrgPosition = get_viewport().get_mouse_position()
				cameraOrgPosition = camera.position
				view = viewportMode.FOLLOW
				
				
			if event.button_index == BUTTON_LEFT:
				couldDraw = true
				
			if event.button_index == BUTTON_RIGHT:
				couldErase = true
				

				
		else:
			view = viewportMode.IDLE
			couldDraw = false
			couldErase = false

	camera.zoom.x = clamp(camera.zoom.x, 0.2, 3)
	camera.zoom.y = clamp(camera.zoom.y, 0.2, 3)


func _process(_delta):
	# match camera mode, then move accordingly
	match view:
		viewportMode.FOLLOW:
			var mouseCurPosition = get_viewport().get_mouse_position()
			var shiftVec = (mouseCurPosition - mouseOrgPosition) * camera.zoom.y
			camera.position = cameraOrgPosition - shiftVec
		viewportMode.IDLE:
			pass
	
	match cursor:
		cursorMode.BRUSHING:
			if couldDraw:
				brushing(0)
			if couldErase:
				brushing(-1)
		cursorMode.PLACING:
			if couldDraw:
				if Input.is_action_just_pressed("mouse_left_pressing"):
					print(placingInstance.name)
					level.get_node(placingType).add_child(placingInstance)
		

# cursor display system
