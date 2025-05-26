extends RigidBody2D

@onready var sprite:=$Sprite2D as Sprite2D
@onready var col:=$CollisionShape2D as CollisionShape2D
@onready var smoke := $CPUParticles2D as CPUParticles2D
@onready var light := $PointLight2D as PointLight2D
@onready var char := $GPUParticles2D2 as GPUParticles2D

var attack_damage = 1

func set_damage(damage: int):
	attack_damage = damage

func set_params(mass_center: float, inert:float):
	center_of_mass.x = mass_center
	inertia = inert

func _process(delta):
	if randf() < 0.3 && char.one_shot == false:
		char.emitting = true
	else:
		char.emitting = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		body.take_damage(attack_damage, 3, position)
	if body.is_in_group("Burnable"):
		body.burn()
	
	call_deferred("disable")

func disable():
	freeze = true
	col.disabled = true
	sprite.visible = false
	light.enabled = false
	smoke.one_shot = true
	char.one_shot = true


func _on_cpu_particles_2d_finished() -> void:
	queue_free()
