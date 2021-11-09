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

# viewport control
var view = viewportMode.IDLE
var mouseOrgPosition : Vector2
var cameraOrgPosition : Vector2
var zoomStep = Vector2(0.1, 0.1)

# tool general variable
var cursor = cursorMode.BRUSHING

# item placing 
var placingInstance
var selectedList = []

# tilemap brush
var brushSize = Vector2(1, 1)

onready var camera = $Camera2D

# brush tool
func brushing():
	print(get_global_mouse_position())

# add total 5 group for different object types
func add_node_group()-> void:
	var groups = ['TileGroup', 'PlayerGroup', 'EnemyGroup',
				 'DecorationGroup', 'ObstacalGroup']

	for group in groups:
		var newGroup = Node2D.new()
		newGroup.name = group
		$Level.add_child(newGroup)
		newGroup.owner = $Level
		
		if group == "TileGroup":
			pass



# add all tilemap to the tilegroup
func add_all_tilemap() -> void:
	pass


func _ready():
	add_node_group()

func _input(event):
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
		else:
			view = viewportMode.IDLE

	camera.zoom.x = clamp(camera.zoom.x, 0.5, 3)
	camera.zoom.y = clamp(camera.zoom.y, 0.5, 3)


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
			pass
		

# cursor display system
