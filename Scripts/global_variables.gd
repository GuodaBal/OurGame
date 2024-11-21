extends Node

var load = false
var starting_level = "starting_level"
var GabijaDone = false
var MedeinaDone = false
var PerkunasDone = false

func reset():
	load = false
	starting_level = "starting_level"
	GabijaDone = false
	MedeinaDone = false
	PerkunasDone = false
	
func save_data():
	var save_dict = {
		"starting_level" : starting_level,
		"GabijaDone" : GabijaDone,
		"MedeinaDone" : MedeinaDone,
		"PerkunasDone" : PerkunasDone
	}
	return save_dict
	
func load_data():
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
		# Now we set the remaining variables.
		for i in node_data.keys():
			set(i, node_data[i])
