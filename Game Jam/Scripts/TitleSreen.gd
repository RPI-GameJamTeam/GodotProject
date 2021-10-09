extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("fade away")

func _on_Button_pressed():
	$AnimationPlayer.play("fade away")

func _on_AnimationPlayer_animation_finished(_anim_name):
	get_tree().change_scene("res://Scenes/MainScene.tscn")
	self.queue_free()
