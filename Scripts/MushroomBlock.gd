extends Area2D

export var coinNumber : int = 1
onready var bumpSound = get_node("/root/GamePlay/Sounds/Bump")
onready var coinSound = get_node("/root/GamePlay/Sounds/Grow")

export var invisible = false

func _ready():
	$Mushroom.hide()
	$Mushroom.set_physics_process(false)
	$Mushroom/CollisionShape2D.disabled = true
	if invisible == true:
		$KinematicBody2D/CollisionShape2D.disabled = true

func _on__Block_body_entered(body):
	if body.get_name() == "Player":
		if body.position.y > position.y and abs(body.position.x - position.x) <= 7:
			if invisible == true:
				$KinematicBody2D/CollisionShape2D.disabled = false
			bumpSound.play()
			if coinNumber > 0:
				Global.coins += 1
				coinNumber -= 1
				coinSound.play()
				$Tween.interpolate_property(self, "position", position, position - Vector2(0, 10), 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				$Tween.start()
				$Mushroom.show()
				var t = Timer.new()
				t.set_wait_time(0.1)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				$Tween.interpolate_property(self, "position", position, position + Vector2(0, 10), 0.1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
				$Tween.start()
				$Mushroom.set_physics_process(true)
				$Mushroom/CollisionShape2D.disabled = false
				t.queue_free()
			if coinNumber == 0:
				$Sprite.animation = "Deactive"
