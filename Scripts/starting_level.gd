extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_forest_sound()
	AudioManager.play_forestfire_sound()
	AudioManager.stop_mainmenu()
	if !GlobalVariables.StartDialogueDone:
		await get_parent().get_node("AnimationPlayer").animation_finished
		DialogueManager.show_dialogue_balloon(load("res://Dialogue/start.dialogue"), "start")
		GlobalVariables.StartDialogueDone = true
