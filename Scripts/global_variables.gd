extends Node

var load = false
var starting_level = "starting_level"
var GabijaDone = false
var MedeinaDone = false
var PerkunasDone = false
var AliveEnemies = {}
var attack_damage = 2
var arrow_damage = 1
var thunder_damage = 3

func reset():
	load = false
	starting_level = "starting_level"
	GabijaDone = false
	MedeinaDone = false
	PerkunasDone = false
	AliveEnemies = {}
	var attack_damage = 2
	var arrow_damage = 1
	var thunder_damage = 3
	
func save_data():
	var save_dict = {
		"starting_level" : starting_level,
		"GabijaDone" : GabijaDone,
		"MedeinaDone" : MedeinaDone,
		"PerkunasDone" : PerkunasDone,
		"AliveEnemies" : AliveEnemies
	}
	return save_dict
	
func load_data():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_as_text()
	save_file.close()
	var json = JSON.parse_string(json_string)
	var data = json["global"]
	for i in data.keys():
		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
			continue
		set(i, data[i])
