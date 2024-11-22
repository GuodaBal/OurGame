extends Node


var previousLevel = "";
@onready var audio = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load data
	if GlobalVariables.load:
		print_debug("loaded")
		if not FileAccess.file_exists("user://savegame.save"):
			print_debug("no file")
		GlobalVariables.load_data()
	previousLevel = str(GlobalVariables.starting_level)
	#add level
	var instance = load("res://tscn_files/Levels/" + str(GlobalVariables.starting_level) + ".tscn").instantiate()
	add_child(instance)
	if GlobalVariables.load:
		get_tree().get_nodes_in_group("Player")[0].load_data()
	AudioPlayer.stop()
	if(AudioManager.current_music == null):	
		AudioManager.current_music = audio
		AudioManager.play_music(audio.stream)
	else:
		AudioManager.play_music(audio.stream)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		var instance = load("res://tscn_files/ui_popup_menu.tscn").instantiate()
		get_child(0).add_sibling(instance)
		
#For spawnpoints in scenes
func changePreviousLevel(levelName):
	previousLevel=levelName
func getPreviousLevel():
	return previousLevel
	
func switchLevel(nextLevel):
	call_deferred("switchLevelDeferred", nextLevel)
func switchLevelDeferred(nextLevel):
	var instance = load("res://tscn_files/Levels/" + nextLevel + ".tscn").instantiate()
	var deleteLevel
	var newLevel
	for child in get_children():
		if "Level" in child.name:
			deleteLevel = child
	#Saving enemies that are alive in scene
	GlobalVariables.AliveEnemies[str(deleteLevel.scene_file_path)] = []
	for child in deleteLevel.get_children():
		if child.is_in_group("Enemy"):
			GlobalVariables.AliveEnemies[str(deleteLevel.scene_file_path)].append(child.name)
	remove_child(deleteLevel)
	deleteLevel.queue_free()
	add_child(instance)
	previousLevel = nextLevel
	#Getting rid of enemies that are dead in new scene
	for child in get_children():
		if "Level" in child.name:
			newLevel = child
	if GlobalVariables.AliveEnemies.has(str(newLevel.scene_file_path)):
		#If there are no enemies, chance to respawn
		if GlobalVariables.AliveEnemies[str(newLevel.scene_file_path)].is_empty():
			for child in newLevel.get_children():
				if child.is_in_group("Enemy") and randf_range(0,1) > 0.2:
					child.queue_free()
		else:
			for child in newLevel.get_children():
				if child.is_in_group("Enemy") and !GlobalVariables.AliveEnemies[str(newLevel.scene_file_path)].has(child.name):
					child.queue_free()
