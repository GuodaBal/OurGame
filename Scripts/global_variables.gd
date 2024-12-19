extends Node

var load = false #If a save file is being loaded
var starting_level = "starting_level" #Level that the player spawns in

var StartDialogueDone = false
var GabijaDone = false
var MedeinaDone = false
var PerkunasDone = false
var AliveEnemies = {}
var NotBurnedObjects = {}
var NotObtainedBoosts = {}
#neccessary to keep player consistant between screens
var attack_damage = 3
var arrow_damage = 1
var thunder_damage = 2
var currentHP = 12
var maxHP = 12

func reset():
	load = false
	starting_level = "starting_level"
	StartDialogueDone = false
	GabijaDone = false
	MedeinaDone = false
	PerkunasDone = false
	AliveEnemies = {}
	NotBurnedObjects = {}
	attack_damage = 3
	arrow_damage = 1
	thunder_damage = 2
	currentHP = 12
	maxHP = 12
func save_data():
	var save_dict = {
		"starting_level" : starting_level,
		"StartDialogueDone" : StartDialogueDone,
		"GabijaDone" : GabijaDone,
		"MedeinaDone" : MedeinaDone,
		"PerkunasDone" : PerkunasDone,
		"AliveEnemies" : AliveEnemies,
		"NotBurnedObjects" : NotBurnedObjects,
		"NotObtainedBoosts" : NotObtainedBoosts,
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
