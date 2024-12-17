extends Area2D
@onready var audio = $AudioStreamPlayer
func _ready() -> void:
	$AnimatedSprite2D.play("default")
func save_data():
	DialogueManager.show_dialogue_balloon(load("res://Dialogue/save_point.dialogue"), "start")
	AudioManager.play_with_random_pitch(audio)
	GlobalVariables.load = true 
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_data = {}
	
	save_data["MainCharacter"] = get_tree().get_nodes_in_group("Player")[0].save_data()
	save_data["global"] = GlobalVariables.save_data()
	save_file.store_string(JSON.stringify(save_data))
