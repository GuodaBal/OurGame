extends AnimatableBody2D

@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var audio = $AudioStreamPlayer2D

func spawn(speed):
	animation.play("spawn", -1 , speed)
	AudioManager.play_with_random_pitch2D(audio,300)

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(1, 1, position)


func _on_death_timer_timeout() -> void:
	queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$DeathTimer.start()
