extends Area2D

@export var nextLevel : String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && nextLevel.length() > 0:
		get_tree().current_scene.switchLevel(nextLevel)
