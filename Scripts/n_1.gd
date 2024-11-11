extends Node2D

@onready var audio = $"../AudioStreamPlayer"

func _on_ready() -> void:
	AudioManager.play_music(audio.stream)
	AudioManager.current_music = audio
