extends KinematicBody2D

var dir = 1 # 1 = Right, -1 = Left

var spd : float = 0
var maxSpd : float = 100
var moveSpd : float = 300
var gravity : float = 980
var maxHeight : float = -350

var velocity = Vector2()

var walking = false
var jumping = false
var canJump = false
var invincible = false

var isStomping = false

export var deathHeight : float = 160

onready var jumpSound = get_node("/root/GamePlay/Sounds/Jump")
onready var stompSound = get_node("/root/GamePlay/Sounds/Stomp")
onready var growSound = get_node("/root/GamePlay/Sounds/Grow")

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("Run"):
		maxHeight = -400
		moveSpd = 600
	if Input.is_action_just_released("Run"):
		maxHeight = -350
		moveSpd = 300
	
	if Input.is_action_pressed("Left"):
		dir = -1
		$AnimatedSprite.flip_h = true
		velocity.x -= moveSpd * delta
	if Input.is_action_pressed("Right"):
		dir = 1
		$AnimatedSprite.flip_h = false
		velocity.x += moveSpd * delta
	# Jump
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		jumping = true
		jumpSound.play()
	if jumping == true:
		if Input.is_action_pressed("Jump") and canJump == true:
			velocity.y -= delta * 4000
		if Input.is_action_just_released("Jump"):
			canJump = false
		if velocity.y < maxHeight:
			canJump = false
	# Animation
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		walking = true
	else:
		walking = false
	if Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
		walking = false
	if walking == true:
		if Global.big:
			$AnimatedSprite.animation = "WalkBig"
		else:
			$AnimatedSprite.animation = "Walk"
	else:
		if Global.big:
			$AnimatedSprite.animation = "IdleBig"
		else:
			$AnimatedSprite.animation = "Idle"
	velocity.y += delta * gravity
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if velocity.x != 0:
		velocity.x = lerp(velocity.x, 0, delta * 3)
	if is_on_floor():
		jumping = false
		canJump = true
	if jumping == true:
		if Global.big:
			$AnimatedSprite.animation = "JumpBig"
		else:
			$AnimatedSprite.animation = "Jump"
		
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		var collider := collision.collider
		var isStomping := (
			collider is Enemy and
			is_on_floor() and
			collision.normal.dot(Vector2.UP) > 0.4
		)
		if collider is Mushroom:
			Global.big = true
			growSound.play()
			(collider as Mushroom).queue_free()
		
		if collider is Spike and isStomping == false:
			if Global.big == true:
				Global.big = false
				invincible = true
				$AnimatedSprite.modulate = Color(0, 0, 1)
				var t = Timer.new()
				t.set_wait_time(3)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				invincible = false
				$AnimatedSprite.modulate = Color(1, 1, 1)
				t.queue_free()
			else:
				if invincible == false:
					Global.lives -= 1
					if Global.lives <= 0:
						get_tree().change_scene("res://Scenes/MainMenu.tscn")
					else:
						get_tree().reload_current_scene()
		
		if isStomping:
			velocity.y -= 100
			stompSound.play()
			Global.score += 50
			(collider as Enemy).kill()
		elif isStomping == false and collider is Enemy:
			if Global.big == true:
				Global.big = false
				invincible = true
				$AnimatedSprite.modulate = Color(0, 0, 1)
				var t = Timer.new()
				t.set_wait_time(3)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				invincible = false
				$AnimatedSprite.modulate = Color(1, 1, 1)
				t.queue_free()
			else:
				if invincible == false:
					Global.lives -= 1
					if Global.lives <= 0:
						get_tree().change_scene("res://Scenes/MainMenu.tscn")
					else:
						get_tree().reload_current_scene()
	
	if Global.big:
		$CollisionShape2D.shape.extents = Vector2(8, 12)
		$CollisionShape2D.position = Vector2(0, -4)
	else:
		$CollisionShape2D.shape.extents = Vector2(8, 8)
		$CollisionShape2D.position = Vector2(0, 0)
