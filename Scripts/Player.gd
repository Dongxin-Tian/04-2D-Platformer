extends KinematicBody2D

var dir = 1 # 1 = Right, -1 = Left

var spd : float = 0
var maxSpd : float = 100
var moveSpd : float = 300
var gravity : float = 980

var velocity = Vector2()

var walking = false
var jumping = false
var canJump = false

var isStomping = false

func _ready():
	pass

func _physics_process(delta):
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
	if jumping == true:
		if Input.is_action_pressed("Jump") and canJump == true:
			velocity.y -= delta * 4000
		if velocity.y < -300:
			canJump = false
	# Animation
	if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		walking = true
	else:
		walking = false
	if Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
		walking = false
	if walking == true:
		$AnimatedSprite.animation = "Walk"
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
		$AnimatedSprite.animation = "Jump"
		
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		var collider := collision.collider
		var isStomping := (
			collider is Enemy and
			is_on_floor() and
			collision.normal.dot(Vector2.UP) > 0.4
		)
		
		if isStomping:
			velocity.y -= 100
			(collider as Enemy).kill()
