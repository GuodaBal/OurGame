extends RigidBody2D

@onready var sprite:=$Sprite2D as Sprite2D
@onready var col:=$CollisionShape2D as CollisionShape2D

var attack_damage = 1

func set_damage(damage: int):
	attack_damage = damage

func set_params(mass_center: float, inert:float):
	center_of_mass.x = mass_center
	inertia = inert

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		body.take_damage(attack_damage, 3, position)
	if body.is_in_group("Burnable"):
		body.burn()
	queue_free()
