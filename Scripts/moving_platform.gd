extends Node2D

@onready var animation := $MovingPlatform/AnimationPlayer as AnimationPlayer
@onready var collision := $MovingPlatform/RayCast2D as RayCast2D #Needed to detect if player
@onready var collision2 := $MovingPlatform/RayCast2D2 as RayCast2D #is touching the side to
#prevent them from getting pushed into a wall and out of the map 

func _process(delta: float) -> void:
	if collision.is_colliding() or collision2.is_colliding():
		animation.pause()
	else:
		animation.play()
func move(direction, coef):
	animation.play("move_"+direction, -1, 20)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
