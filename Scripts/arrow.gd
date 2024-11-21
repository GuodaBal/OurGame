extends RigidBody2D

@onready var sprite:=$Sprite2D as Sprite2D
@onready var col:=$CollisionShape2D as CollisionShape2D

var attack_damage = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass
	#look_at(Vector2(70000, -30000))
	#apply_central_impulse(Vector2(200, -200))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
	#sprite.rotation = get_angle_to(self.linear_velocity)
	#col.rotation = get_angle_to(self.linear_velocity) + deg_to_rad(90)

func set_damage(damage: int):
	attack_damage = damage

func set_params(mass_center: float, inert:float):
	center_of_mass.x = mass_center
	inertia = inert

func _on_body_entered(body: Node) -> void:
	#print_debug("hit")
	#print_debug(center_of_mass.x)
	#print_debug(inertia)
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		body.take_damage(attack_damage, 3, position)
	if body.is_in_group("Burnable"):
		body.burn()
	queue_free()
