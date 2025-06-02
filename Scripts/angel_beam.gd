extends Node2D

@export var line: Line2D
@onready var particlesStart = $GPUParticles2D
@onready var particlesEnd = $GPUParticles2D2
@onready var particlesBeam = $BeamParticles
@onready var line2d = $Line2D

var _is_casting := false

func _ready() -> void:
	line2d.set_point_position(0, Vector2.ZERO)
	line2d.set_point_position(1, Vector2.ZERO)
	set_process(false)

func play_beam(from: Vector2, to: Vector2) -> void:
	global_position = from
	var local_to = to - from
	line2d.set_point_position(0, Vector2.ZERO)
	line2d.set_point_position(1, local_to)
	
	particlesStart.global_position = from
	particlesEnd.global_position = to
	particlesEnd.rotation = (to - from).angle()

	particlesBeam.global_position = from + (to - from) * 0.5
	particlesBeam.rotation = (to - from).angle() # <-- pridėta
	
	var material := particlesBeam.process_material as ParticleProcessMaterial
	if material:
		var box := material.emission_box_extents
		box = Vector3((to - from).length() * 0.5, 0.5, 0)  # plonas ruožas
		material.emission_box_extents = box
	
	particlesStart.emitting = true
	particlesEnd.emitting = true
	particlesBeam.emitting = true
	
	appear()
	set_process(true)
	await get_tree().create_timer(0.3).timeout
	disappear()

func appear() -> void:
	var tween = create_tween()
	tween.tween_property(line2d, "width", 10.0, 0.2)

func disappear() -> void:
	var tween = create_tween()
	tween.tween_property(line2d, "width", 0.0, 0.2)
	await tween.finished
	set_process(false)
