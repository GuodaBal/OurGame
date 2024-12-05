extends Node2D

@onready var animation := $AnimationPlayer as AnimationPlayer

func move(direction):
	animation.play("move_"+direction)
