extends AnimatableBody2D

@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var shader = $Cracks.material.duplicate(true)
@onready var gradient = shader.get_shader_parameter("cracks").color_ramp as Gradient
@onready var raycasts = $Node2D

var progress = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("spawn")
	$Cracks.material = shader
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	gradient.set_offset(1, progress)

func _process(delta: float) -> void:
	if animation.is_playing() && animation.current_animation == "spawn":
		progress = clamp(progress + delta * 0.1, 0.01, 0.1)
	elif animation.is_playing() && animation.current_animation == "despawn":
		progress = clamp(progress - delta * 0.1, 0.01, 0.1)
	if gradient:
		gradient.set_offset(1, progress)


func _on_despawn_timeout() -> void:
	animation.play("despawn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "despawn":
		queue_free()
