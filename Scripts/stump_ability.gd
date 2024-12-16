extends AnimatableBody2D

@onready var animation := $AnimationPlayer as AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("spawn")
	

func _on_despawn_timeout() -> void:
	queue_free()
