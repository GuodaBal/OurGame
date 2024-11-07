extends Node2D

var health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.gain_hp(health)
		queue_free()
