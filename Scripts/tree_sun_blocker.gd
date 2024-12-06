extends AnimatableBody2D

@onready var animation := $AnimationPlayer as AnimationPlayer 

func grow():
	animation.play("grow")

func burn():
	animation.play("burning")
	await animation.animation_finished
	get_parent().unblock_sun()
	#queue_free()
