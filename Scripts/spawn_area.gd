extends Node2D

@export var correctLevel: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(get_tree().current_scene.getPreviousLevel()==correctLevel):
		get_parent().get_parent().get_node("MainCharacter").position = position
	queue_free()
