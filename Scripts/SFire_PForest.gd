extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_forestfire_sound()
	AudioManager.stop_water_sound()
	AudioManager.play_forest_sound()