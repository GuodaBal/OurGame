extends AnimatedSprite2D

@onready var timer := $AnimationTimer as Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(randf_range(2, 7))
	play("idle")


func _on_animation_timer_timeout() -> void:
	timer.start(randf_range(2, 7))
	play("idle")
