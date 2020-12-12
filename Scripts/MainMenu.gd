extends Control

onready var Continue = get_node("Continue")
onready var NewGame = get_node("NewGame")
onready var Quit = get_node("Quit")

var selection : int

func _ready():
	selection = 0
	Select()
	
func _process(_delta):
	if Input.is_action_just_pressed("Up"):
		if selection == 0:
			selection = 2
		else:
			selection -= 1
		Select()
		$SelectSound.play()
	if Input.is_action_just_pressed("Down"):
		if selection == 2:
			selection = 0
		else:
			selection += 1
		Select()
		$SelectSound.play()
	if Input.is_action_just_pressed("Jump") or Input.is_action_just_pressed("Start"):
		Confirm()
	
func Select():
	if selection == 0:
		SetDefaultColor()
		Continue.add_color_override("font_color", Color(1, 1, 1, 1))
	elif selection == 1:
		SetDefaultColor()
		NewGame.add_color_override("font_color", Color(1, 1, 1, 1))
	elif selection == 2:
		SetDefaultColor()
		Quit.add_color_override("font_color", Color(1, 1, 1, 1))	
	
func Confirm():
	$ConfirmSound.play()
	if selection == 0:
		pass
	elif selection == 1:
		pass
	elif selection == 2:
		get_tree().quit()
	
func SetDefaultColor():
	Continue.add_color_override("font_color", Color(1, 1, 1, 0.5))
	NewGame.add_color_override("font_color", Color(1, 1, 1, 0.5))
	Quit.add_color_override("font_color", Color(1, 1, 1, 0.5))
