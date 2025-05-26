extends Node2D

@onready var particles := $GPUParticles2D as GPUParticles2D
var shader
var progress = 0.0
var hit = false

func _ready() -> void:
	shader = $Sprite2D.material.duplicate()
	$Sprite2D.material = shader
	shader.set_shader_parameter("rotation_strength", 0.0)
	shader.set_shader_parameter("random_offset", randf_range(0.0, 1000.0))

func _process(delta: float) -> void:
	if hit:
		progress = lerp(progress, 1.5, delta * 3.0)
		if progress > 1.4:
			hit = false
	else:
		progress = lerp(progress, 0.0, delta/1.5)
	shader.set_shader_parameter("rotation_strength", progress)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		particles.emitting = true
	hit = true
