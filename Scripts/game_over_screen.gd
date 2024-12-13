extends CanvasLayer



func _on_quit_pressed():
	get_tree().quit()


func _on_try_again_pressed():
	if GlobalVariables.load == true and FileAccess.file_exists("user://savegame.save"):
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json_string = save_file.get_as_text()
		save_file.close()
		var json = JSON.parse_string(json_string)
		GlobalVariables.starting_level = json["global"]["starting_level"]
	else:
		GlobalVariables.reset()
	get_tree().change_scene_to_file("res://tscn_files/main.tscn")
