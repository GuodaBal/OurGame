extends StaticBody2D

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D

func burn():
	animation.play("burning")
	await animation.animation_finished
	queue_free()
