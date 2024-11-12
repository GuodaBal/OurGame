extends Node2D

@onready var audio = $"../AudioStreamPlayer"

func _on_ready() -> void:
	AudioManager.current_music = audio
	AudioManager.play_music(audio.stream)
	print("stream", AudioManager.current_music)
