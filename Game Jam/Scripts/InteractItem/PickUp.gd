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


