extends Node2D

var damage = 1

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage, 0, position)
	queue_free()
