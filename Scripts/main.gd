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
		var save_nodes = get_tree().get_nodes_in_group("Persist")
		for i in save_nodes:
			i.load_data()
	
	previousLevel = str(GlobalVariables.starting_level)
	#add level
	var instance = load("res://tscn_files/Levels/" + str(GlobalVariables.starting_level) + ".tscn").instantiate()
	add_child(instance)
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
	for child in get_children():
		if "Level" in child.name:
			deleteLevel = child
	remove_child(deleteLevel)
	deleteLevel.queue_free()
	add_child(instance)
	previousLevel = nextLevel
