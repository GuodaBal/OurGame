extends RigidBody2D

var attack_damage = 1
@onready var splash := $Splash as CPUParticles2D
@onready var shape := $Shape as CPUParticles2D
@onready var trail := $Trail as GPUParticles2D

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.take_damage(attack_damage, 0.2, position)
	set_collision_mask_value(1, false)
	
	freeze = true
	sleeping = true
	
	splash.global_rotation = 0
	splash.emitting = true
	shape.emitting = false
	trail.emitting = false


func _on_cpu_particles_2d_2_finished() -> void:
	queue_free()
