extends Area2D

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var audio = $AudioStreamPlayer
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animation.play("open")
		AudioManager.play_with_random_pitch(audio)		
		await animation.animation_finished
		body.attack_boost()
		DialogueManager.show_dialogue_balloon(load("res://Dialogue/ability.dialogue"), "damage_boost")
		queue_free()
