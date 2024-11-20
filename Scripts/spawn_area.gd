extends Node2D

@export var correctLevel: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(get_parent().get_parent().getPreviousLevel()==correctLevel):
		get_tree().get_nodes_in_group("Player")[0].position = position
	queue_free()
