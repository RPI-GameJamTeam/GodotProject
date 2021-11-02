extends Node2D

# tools we need
# brush for the tile
# load asset to the menu
# move tool
# delete tool
# select tool

func _ready():
	var groups = ['TileGroup', 'PlayerGroup', 'EnemyGroup', 'DecorationGroup', 'ObstacalGroup']
	 
	for group in groups:
		var newGroup = Node2D.new()
		newGroup.name = group
		self.add_child(newGroup)
		
	
