extends Node2D

# tools we need
# brush for the tile
# load asset to the menu
# move tool
# delete tool
# select tool

enum viewportMode {FOLLOW, ZOOM_UP, ZOOM_DOWN, IDLE}
var curViewMode = viewportMode.IDLE
var mouseOrgPosition : Vector2
var cameraOrgPosition : Vector2
onready var camera = $Camera2D

func _ready():
	var groups = ['TileGroup', 'PlayerGroup', 'EnemyGroup', 'DecorationGroup', 'ObstacalGroup']
	 
	for group in groups:
		var newGroup = Node2D.new()
		newGroup.name = group
		$Level.add_child(newGroup)
		newGroup.owner = $Level
		
	
func _input(event):
	
	# screen control
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_DOWN:
				curViewMode = viewportMode.ZOOM_DOWN
			if event.button_index == BUTTON_WHEEL_UP:
				curViewMode = viewportMode.ZOOM_UP
			if event.button_index == BUTTON_MIDDLE:
				mouseOrgPosition = get_viewport().get_mouse_position()
				cameraOrgPosition = camera.position
				curViewMode = viewportMode.FOLLOW
		else:
			curViewMode = viewportMode.IDLE
			
	if event is InputEventMouseMotion:
#		print(event.position)	
		pass
		
func _process(delta):
	
	match curViewMode:
		viewportMode.FOLLOW:
			var mouseCurPosition = get_viewport().get_mouse_position()
			var shiftVec = mouseCurPosition - mouseOrgPosition
			camera.position = cameraOrgPosition - shiftVec
		viewportMode.ZOOM_DOWN:
			pass
		viewportMode.ZOOM_UP:
			pass
		viewportMode.IDLE:
			pass
	
