extends StaticBody2D

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var shader

@onready var fire_particles_1 := $CPUParticles2D as CPUParticles2D
@onready var fire_particles_2 := $CPUParticles2D2 as CPUParticles2D
@onready var fall_particles := $Fall_particles as GPUParticles2D

var strength = 0

func _ready() -> void:
	shader = $Sprite2D.material.duplicate()
	$Sprite2D.material = shader

func burn():
	$AnimationPlayer.play("burn")
	animation.play("burning")

func _process(delta: float) -> void:
	if animation.is_playing() && animation.animation == "burning":
		strength += delta * 1.5
		shader.set_shader_parameter("strength", strength)
	shader.set_shader_parameter("modulate",  $Sprite2D.modulate)

func _on_fall_particles_finished() -> void:
	queue_free()

func start_fire():
	fire_particles_1.emitting = true
	fire_particles_1.get_child(0).emitting = true
	fire_particles_2.emitting = true
	fire_particles_2.get_child(0).emitting = true

func stop_fire():
	fire_particles_1.emitting = false
	fire_particles_1.get_child(0).emitting = false
	fire_particles_2.emitting = false
	fire_particles_2.get_child(0).emitting = false
