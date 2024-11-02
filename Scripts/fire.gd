extends Node2D

var damage = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage, 0, position)
