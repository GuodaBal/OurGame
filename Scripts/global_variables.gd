extends Node

var load = false #If a save file is being loaded
var starting_level = "starting_level" #Level that the player spawns in

var GabijaDone = false
var MedeinaDone = false
var PerkunasDone = false
var AliveEnemies = {}
#neccessary to keep player consistant between screens
var attack_damage = 10.125
var arrow_damage = 3.375
var thunder_damage = 6.75
var currentHP = 24
var maxHP = 24

func reset():
	load = false
	starting_level = "starting_level"
	GabijaDone = false
	MedeinaDone = false
	PerkunasDone = false
	AliveEnemies = {}
	attack_damage = 10.125
	arrow_damage = 3.375
	thunder_damage = 6.75
	currentHP = 24
	maxHP = 24
func save_data():
	var save_dict = {
		"starting_level" : starting_level,
		"GabijaDone" : GabijaDone,
		"MedeinaDone" : MedeinaDone,
		"PerkunasDone" : PerkunasDone,
		"AliveEnemies" : AliveEnemies,
		"attack_damage" : attack_damage,
		"arrow_damage" : arrow_damage,
		"thunder_damage" : thunder_damage,
		"currentHP" : currentHP,
		"maxHP" : maxHP
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
