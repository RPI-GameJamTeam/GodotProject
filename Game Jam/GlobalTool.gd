extends Node

enum ElementState { PARTICLE, WATER, FIRE, AIR, EARTH }
var dirPath = "res://Scenes/"

func get_color(index_value):
	if index_value == ElementState.WATER:
		return Color(13/255.0, 218/255.0, 203/255.0, 5)
	elif index_value == ElementState.FIRE:
		return Color(234/255.0, 86/255.0, 21/255.0)
	elif index_value == ElementState.AIR:
		return Color(137/255.0, 201/255.0, 207/255.0)
	elif index_value == ElementState.EARTH:
		return Color(205/255.0, 134/255.0, 14/255.0)
	elif index_value == ElementState.PARTICLE:
		return Color(32/255.0, 34/255.0, 123/255.0)


func set_all_glow(index_value):
	for glow_object in get_tree().get_nodes_in_group("Glow"):
		if glow_object.material != null:
			if glow_object is Particles2D:
				glow_object.process_material.color = get_color(index_value)
			else:
				glow_object.material.set_shader_param("glow_color", get_color(index_value))


func speed_clamp(raw_velocity, against_velocity, max_velocity, velocity_factor):
	var velocity = Vector2.ZERO
	var velocity_x = raw_velocity.x
	var velocity_y = raw_velocity.y
	var against_velocity_y = against_velocity.y
	var against_velocity_x = against_velocity.x
	
	velocity_x = clamp(velocity_x, (-max_velocity+against_velocity_x)
	*velocity_factor, (max_velocity+against_velocity_x)*velocity_factor)
	
	velocity_y = clamp(velocity_y, (-max_velocity+against_velocity_y)
	*velocity_factor, (max_velocity+against_velocity_y)*velocity_factor)	
	
	velocity.x = velocity_x
	velocity.y = velocity_y
	
	return velocity


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


# load all object path to a dictionary for later use
func load_resource_path() -> Dictionary:
	var dic = {"Misc":[], "Obs":[], "Picks":[], "Tiles":[]}
	for fileName in dic:
		var path = dirPath + fileName + "/"
		var items = GlobalTool.list_files_in_directory(path)
		for i in items:
			dic[fileName].append(path+i)

	return dic
