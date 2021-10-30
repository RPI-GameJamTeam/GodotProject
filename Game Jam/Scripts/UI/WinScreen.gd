extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationPlayer.play("fade away")
		get_tree().change_scene("res://UI/TitleSreen.tscn")
		queue_free()

func _on_Button_pressed():
	$AnimationPlayer.play("fade away")
	get_tree().change_scene("res://UI/TitleSreen.tscn")
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().get_root().get_child(0).reset_game()
	queue_free()
