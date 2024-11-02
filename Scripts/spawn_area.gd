extends Node2D

@export var correctLevel: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug(get_tree().current_scene.getPreviousLevel())
	print_debug(correctLevel)
	if(get_tree().current_scene.getPreviousLevel()==correctLevel):
		get_parent().get_parent().get_node("Main_character").position = position
	queue_free()
