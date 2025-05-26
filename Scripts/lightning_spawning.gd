extends Node2D

@onready var lightning = preload("res://tscn_files/l_generation.tscn")
@onready var timer = $Timer as Timer
@onready var audio_lightning = $Lightning


func _on_timer_timeout() -> void:
	AudioManager.play_with_random_pitch(audio_lightning)
	var player_pos = get_parent().get_node("MainCharacter").position
	var starting_point = Vector2(player_pos.x + randf_range(-1000, 1000), player_pos.y + randf_range(-1000, -900))
	var instance = lightning.instantiate()
	add_sibling(instance)
	instance.generate_lightning(starting_point)
	timer.start(randf_range(1.5, 8.0))
