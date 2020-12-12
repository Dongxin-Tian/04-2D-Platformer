extends Area2D

func _on_DeathArea_body_entered(body):
	if body.name == "Player":
		Global.lives -= 1
		if Global.lives <= 0:
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
		else:
			get_tree().reload_current_scene()
