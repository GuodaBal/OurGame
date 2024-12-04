extends Node2D

@export var correctLevel: String
signal done
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(get_parent().get_parent().getPreviousLevel()==correctLevel):
		get_tree().get_nodes_in_group("Player")[0].position = position
		await get_tree().process_frame
		done.connect(get_tree().current_scene.done)
		done.emit()
		queue_free()
