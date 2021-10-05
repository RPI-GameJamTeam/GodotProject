extends Node

enum ElementState { PARTICLE, WATER, FIRE, AIR, EARTH }

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
#	elif index_value == ElementState.COOKIE:
#		return Color(100/255.0, 90/255.0, 34/255.0)

func set_all_glow(index_value):
	for glow_object in get_tree().get_nodes_in_group("Glow"):
		if glow_object.material != null:
			if glow_object is Particles2D:
				glow_object.process_material.color = get_color(index_value)
			else:
				glow_object.material.set_shader_param("glow_color", get_color(index_value))
