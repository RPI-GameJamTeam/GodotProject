extends Control



func _on_Button_pressed():
	$AnimationPlayer.play("fade away")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/MainScene.tscn")
	self.queue_free()
