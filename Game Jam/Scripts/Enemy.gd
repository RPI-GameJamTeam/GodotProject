extends KinematicBody2D

export(int, "FLY", "RUN", "IDLE") var setAnimation = 0

enum SPRITE {FLY, RUN, IDLE}

var player_in_area : bool = false 


func _on_CheckPlayer_body_entered(body):
	player_in_area = true


func _on_CheckPlayer_body_exited(body):
	player_in_area = false
	
func _ready():
	print(setAnimation)
	match setAnimation:
		SPRITE.FLY:
			$AnimatedSprite.animation = "fly"
			$AnimatedSprite.play()
		SPRITE.IDLE:
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.play()
		SPRITE.RUN:
			$AnimatedSprite.animation = "run"
			$AnimatedSprite.play()
	playSFX()

func playSFX():
	randomize()
	var t = Timer.new()
	t.set_wait_time(rand_range(15, 30))
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	$SFX.play()
	playSFX()
	
func _process(delta):	
	if player_in_area:
		if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
			get_tree().get_nodes_in_group('Player')[0].die()   

