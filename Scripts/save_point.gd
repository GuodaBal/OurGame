extends Area2D


func save_data():
	print_debug("saved")
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_data = {}
	# Save nodes in the "Persist" group.
	save_data["MainCharacter"] = get_tree().current_scene.get_node("MainCharacter").save_data()
	save_data["global"] = GlobalVariables.save_data()
	save_file.store_string(JSON.stringify(save_data))
