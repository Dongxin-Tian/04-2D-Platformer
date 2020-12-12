extends Node

var level : int = 1
var score : int = 0
var lives : int = 5
var coins : int = 0
var big : bool = false

var path = "user://super_miyamoto.dat"

func Save():
	var data = {
		"level" : level,
		"score" : score,
		"lives" : lives,
		"coins" : coins,
		"big" : big,
	}
	
	var file = File.new()
	var error = file.open(path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()

func Load():
	var file = File.new()
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			var data = file.get_var()
			file.close()
			level = data["level"]
			score = data["score"]
			lives = data["lives"]
			coins = data["coins"]
			big = data["big"]
