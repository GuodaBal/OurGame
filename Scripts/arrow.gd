extends RigidBody2D

var damage = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#look_at(Vector2(70000, -30000))
	#apply_central_impulse(Vector2(700000, -3000000))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	print_debug("hit")
	if body.is_in_group("Enemy"):
		body.take_damage(damage, 3, position)
	if !body.is_in_group("Player"):
		print_debug(body)
		queue_free()
