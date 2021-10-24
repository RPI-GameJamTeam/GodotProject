tool
extends Area2D

export(int, FLAGS, "WATER", "FIRE", "AIR", "EARTH", "COOKIE") var setType = 0
var type : int
enum PickUpType { WATER, FIRE, AIR, EARTH, COOKIE }

var pos

func _ready():
	pos = position
	update_type()
	
func _process(_delta):
	if !Engine.editor_hint:
		position.y = pos.y + sin(OS.get_ticks_msec() / 100)
	else:
		update_type()
	
	if type == PickUpType.COOKIE:
		var player = get_tree().get_nodes_in_group("Player")[0]
		if (player.position - position).length() < 225:
			$AnimatedSprite.play("cookie_cry")
		else:			
			$AnimatedSprite.play("cookie_idle")
	else:
		$AnimatedSprite.play(str(type) + "idle")

func update_type():
	if setType & 1:
		type = PickUpType.WATER
	elif setType & 2:
		type = PickUpType.FIRE
	if setType & 4:
		type = PickUpType.AIR
	elif setType & 8:
		type = PickUpType.EARTH
	elif setType & 16:
		type = PickUpType.COOKIE

func _on_PickUp_body_entered(body):
	if body.is_in_group("Player"):
#		body.get_node("Camera2D").add_trauma(0.6)
#		body.get_node("Camera2D").shake()
		
		
		if type != PickUpType.COOKIE:
			GlobalTool.set_all_glow(type+1)
		
		$Particles2D.restart()
		
		if type == PickUpType.COOKIE:
			$AnimatedSprite.hide()
			$CollisionShape2D.set_deferred("disabled", true)
			
			get_tree().get_nodes_in_group("Main")[0].kill_cookie()
			
			
			var t = Timer.new()
			t.set_wait_time(1.2)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			
			queue_free()
		else:
			body.set_state(type+1)

func getColor():
	if type == PickUpType.WATER:
		return Color(13/255.0, 218/255.0, 203/255.0, 5)
	elif type == PickUpType.FIRE:
		return Color(234/255.0, 86/255.0, 21/255.0)
	elif type == PickUpType.AIR:
		return Color(137/255.0, 201/255.0, 207/255.0)
	elif type == PickUpType.EARTH:
		return Color(205/255.0, 134/255.0, 14/255.0)
	elif type == PickUpType.COOKIE:
		return Color(100/255.0, 90/255.0, 34/255.0)
