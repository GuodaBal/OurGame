extends Node


var previousLevel = "";
var currentLevel = "level"
@onready var audio = $AudioStreamPlayer
#var savedPosition
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previousLevel = "starting_level"
	#var instance = load("res://tscn_files/" + currentLevel + ".tscn").instantiate()
	#add_child(instance)
	#get_node("MainCharacter").position = savedPosition
	AudioManager.current_music = audio
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
	var deleteLevel = get_node("Level")
	remove_child(deleteLevel)
	#call_deferred(deleteLevel)
	deleteLevel.queue_free()
	#get_parent().print_tree()
	add_child(instance)
	previousLevel = nextLevel
	#get_parent().print_tree()
	#queue_free()
