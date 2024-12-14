extends AnimatableBody2D

@onready var animation := $AnimationPlayer as AnimationPlayer 
var can_burn = false
func _ready() -> void:
	#animation.play("RESET")
	pass

func grow():
	animation.play("grow")

func burn():
	if can_burn:
		animation.play("burning")
		get_parent().unblock_sun()
		await animation.animation_finished
		can_burn = false
	#queue_free()
