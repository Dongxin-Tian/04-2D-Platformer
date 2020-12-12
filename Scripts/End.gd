extends Area2D

export var scenePath = ""

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if Global.level == 1:
			Global.level = 2
		else:
			Global.level = 1
		Global.Save()
		if Global.level == 1:
			get_tree().change_scene("res://Scenes/Level3.tscn")
		else:
			get_tree().change_scene("res://Scenes/Level2.tscn")
