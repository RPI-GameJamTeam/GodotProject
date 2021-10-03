extends Area2D

export var type : int

enum PickUpType { WATER, FIRE, AIR, EARTH, COOKIE }

func _process(delta):
	if type == PickUpType.COOKIE:
		var player = get_tree().get_nodes_in_group("Player")[0]
		if (player.position - position).length() < 225:
			$AnimatedSprite.play("cookie_cry")
		else:			
			$AnimatedSprite.play("cookie_idle")
	else:
		$AnimatedSprite.play(str(type) + "idle")

func _on_PickUp_body_entered(body):
	if body.is_in_group("Player"):
		body.get_node("Camera2D").add_trauma(0.6)
		body.get_node("Camera2D").shake()
		$Particles2D.restart()
		
		if type == PickUpType.COOKIE:
			$AnimatedSprite.visible = false			
			$CollisionShape2D.set_deferred("disabled", true)
			
			var t = Timer.new()
			t.set_wait_time(3)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			queue_free()
		else:
			body.set_state(type+1)
