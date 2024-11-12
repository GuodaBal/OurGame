extends Node2D

@onready var audio = $"../AudioStreamPlayer"

func _on_ready() -> void:
	if(AudioManager.current_music == null):	
		AudioManager.current_music = audio
		AudioManager.play_music(audio.stream)
	else:
		AudioManager.play_music(audio.stream)
