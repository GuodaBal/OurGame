extends RigidBody2D

@onready var sprite:=$Sprite2D as Sprite2D
@onready var col:=$CollisionShape2D as CollisionShape2D
var damage = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#look_at(Vector2(70000, -30000))
	#apply_central_impulse(Vector2(200, -200))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	sprite.rotation = get_angle_to(self.linear_velocity)
	col.rotation = get_angle_to(self.linear_velocity) + deg_to_rad(90)
	

func _on_body_entered(body: Node) -> void:
	#print_debug("hit")
	if body.is_in_group("Enemy"):
		body.take_damage(damage, 3, position)
	queue_free()
