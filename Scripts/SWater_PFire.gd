extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_water_sound()
	AudioManager.stop_forest_sound()
	AudioManager.play_forestfire_sound()
