extends RigidBody2D

var attack_damage = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.take_damage(attack_damage, 0.2, position)
	queue_free()
