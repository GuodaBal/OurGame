extends Node


var previousLevel = "";
@onready var audio = $AudioStreamPlayer
@onready var transition = $AnimationPlayer as AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load data
	if GlobalVariables.load:
		if not FileAccess.file_exists("user://savegame.save"):
			print_debug("no file")
		GlobalVariables.load_data()
	previousLevel = str(GlobalVariables.starting_level)
	#add level
	var instance = load("res://tscn_files/Levels/" + str(GlobalVariables.starting_level) + ".tscn").instantiate()
	add_child(instance)
	if GlobalVariables.load:
		get_tree().get_nodes_in_group("Player")[0].load_data()
		#Checks if enemies were killed
		if GlobalVariables.AliveEnemies.has(str(instance.scene_file_path)):
		#If there are no enemies, chance to respawn
			if GlobalVariables.AliveEnemies[str(instance.scene_file_path)].is_empty():
				for child in instance.get_children():
					if child.is_in_group("Enemy") and randf_range(0,1) > 0.2:
						child.queue_free()
			else:
				for child in instance.get_children():
					if child.is_in_group("Enemy") and !GlobalVariables.AliveEnemies[str(instance.scene_file_path)].has(child.name):
						child.queue_free()
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
	
func done():
	var can_play = true
	#Finds if level has a canvasmodulate, it interferes with transition
	for node in get_tree().current_scene.get_children():
		if "Level" in node.name:
			for child in node.get_children():
				if child is CanvasModulate:
					can_play = false
	if can_play:
		transition.play("Fade_in")
	else:
		transition.play("Hide")
func switchLevel(nextLevel):
	transition.play("Fade_out")
	await transition.animation_finished
	call_deferred("switchLevelDeferred", nextLevel)
	#transition.play("Fade_out")
func switchLevelDeferred(nextLevel):
	var instance = load("res://tscn_files/Levels/" + nextLevel + ".tscn").instantiate()
	var deleteLevel
	var newLevel
	for child in get_children():
		if "Level" in child.name:
			deleteLevel = child
	GlobalVariables.AliveEnemies[str(deleteLevel.scene_file_path)] = []
	GlobalVariables.NotBurnedObjects[str(deleteLevel.scene_file_path)] = []
	GlobalVariables.NotObtainedBoosts[str(deleteLevel.scene_file_path)] = []
	for child in deleteLevel.get_children():
		#Saving enemies that are alive in scene
		if child.is_in_group("Enemy"):
			GlobalVariables.AliveEnemies[str(deleteLevel.scene_file_path)].append(child.name)
		#Saving objects that weren't burned
		if child.is_in_group("Burnable"):
			GlobalVariables.NotBurnedObjects[str(deleteLevel.scene_file_path)].append(child.name)
		#Saving boosts that weren't obtained
		if child.is_in_group("Boost"):
			GlobalVariables.NotObtainedBoosts[str(deleteLevel.scene_file_path)].append(child.name)
	remove_child(deleteLevel)
	deleteLevel.queue_free()
	add_child(instance)
	previousLevel = nextLevel
	for child in get_children():
		if "Level" in child.name:
			newLevel = child
	#Need to confirm data was saved for level before accessing
	if GlobalVariables.AliveEnemies.has(str(newLevel.scene_file_path)):
		for child in newLevel.get_children():
			#If there are no enemies, chance to respawn
			if GlobalVariables.AliveEnemies[str(newLevel.scene_file_path)].is_empty():
				if child.is_in_group("Enemy") and randf_range(0,1) > 0.2:
					child.queue_free()
			else:
				#If enemy not in save file, it is dead and will be erased, same for others
				if child.is_in_group("Enemy") and !GlobalVariables.AliveEnemies[str(newLevel.scene_file_path)].has(child.name):
					child.queue_free()
				if child.is_in_group("Burnable") and !GlobalVariables.NotBurnedObjects[str(newLevel.scene_file_path)].has(child.name):
					child.queue_free()
				if child.is_in_group("Boost") and !GlobalVariables.NotObtainedBoosts[str(newLevel.scene_file_path)].has(child.name):
					child.queue_free()
