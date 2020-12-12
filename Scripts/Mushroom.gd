extends KinematicBody2D
class_name Mushroom

const FLOOR_NORMAL := Vector2.UP

export var speed := Vector2(40.0, 50.0)
export var gravity := 3500.0
export var stomp_impulse := 600.0

var velocity := Vector2.ZERO

func _ready() -> void:
	set_physics_process(true)
	velocity.x = -speed.x
	
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x *= -1 if is_on_wall() else 1
	velocity.y = move_and_slide(velocity, FLOOR_NORMAL).y
