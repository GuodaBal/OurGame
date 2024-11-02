extends Area2D

@export var nextLevel : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && nextLevel.length() > 0:
		#get_parent().print_tree()
		get_tree().current_scene.switchLevel(nextLevel)
