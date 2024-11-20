extends Node


var previousLevel = "";
@onready var audio = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.load:
		print_debug("loaded")
		if not FileAccess.file_exists("user://savegame.save"):
			print_debug("no file")
		# We need to revert the game state so we're not cloning objects
		# during loading. This will vary wildly depending on the needs of a
		# project, so take care with this step.
		# For our example, we will accomplish this by deleting saveable objects.
		
		var save_nodes = get_tree().get_nodes_in_group("Persist")
		for i in save_nodes:
			i.queue_free()
		await get_tree().process_frame
		# Load the file line by line and process that dictionary to restore
		# the object it represents.
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()

			# Creates the helper class to interact with JSON.
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure.
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			# Get the data from the JSON object.
			var node_data = json.data

			# Firstly, we need to create the object and add it to the tree and set its position.
			var new_object = load(node_data["filename"]).instantiate()
			get_node(node_data["parent"]).add_child(new_object)
			new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
			print_debug(node_data["pos_x"])
			print_debug(node_data["pos_y"])
			# Now we set the remaining variables.
			for i in node_data.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				new_object.set(i, node_data[i])
	
	previousLevel = "starting_level"
	#print_debug(GlobalVariables.starting_level)
	#print_debug("res://tscn_files/Levels/" + str(GlobalVariables.starting_level) + ".tscn")
	var instance = load("res://tscn_files/Levels/" + str(GlobalVariables.starting_level) + ".tscn").instantiate()
	add_child(instance)
	#get_node("MainCharacter").position = savedPosition
	AudioPlayer.stop()
	if(AudioManager.current_music == null):	
		AudioManager.current_music = audio
		AudioManager.play_music(audio.stream)
	else:
		AudioManager.play_music(audio.stream)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		var instance = load("res://tscn_files/ui_popup_menu.tscn").instantiate()
		get_child(0).add_sibling(instance)
		
func changePreviousLevel(levelName):
	previousLevel=levelName
	
	
func getPreviousLevel():
	return previousLevel
	
func switchLevel(nextLevel):
	var instance = load("res://tscn_files/Levels/" + nextLevel + ".tscn").instantiate()
	#get_parent().print_tree()
	var deleteLevel# = get_node("Level")
	for child in get_children():
		if "Level" in child.name:
			deleteLevel = child
	remove_child(deleteLevel)
	#call_deferred(deleteLevel)
	deleteLevel.queue_free()
	#get_parent().print_tree()
	add_child(instance)
	previousLevel = nextLevel
	#get_parent().print_tree()
	#queue_free()
