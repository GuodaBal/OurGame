extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_forest_sound()
	AudioManager.play_water_sound()
