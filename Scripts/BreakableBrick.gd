extends Area2D

onready var bumpSound = get_node("/root/GamePlay/Sounds/Bump")
onready var shatterSound = get_node("/root/GamePlay/Sounds/Shatter")

func _on_Brick_body_entered(body):
	if body.get_name() == "Player":
		if body.position.y > position.y and abs(body.position.x - position.x) <= 6:
			if Global.big == true:
				shatterSound.play()
				queue_free()
			else:
				bumpSound.play()
				$Tween.interpolate_property(self, "position", position, position - Vector2(0, 10), 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				$Tween.start()
				var t = Timer.new()
				t.set_wait_time(0.1)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				$Tween.interpolate_property(self, "position", position, position + Vector2(0, 10), 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				$Tween.start()
				t.queue_free()
