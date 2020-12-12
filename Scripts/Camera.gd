extends Camera2D

onready var player = get_node("/root/GamePlay/Player")

export var leftEnd : float
export var rightEnd : float

func _physics_process(_delta):
	position.x = player.position.x
	if position.x < leftEnd:
		position.x = leftEnd
	if position.x > rightEnd:
		position.x = rightEnd
