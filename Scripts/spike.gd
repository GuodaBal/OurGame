extends Node2D

var damage = 1
var speed = 0.7
@onready var path := $Path2D/PathFollow2D as PathFollow2D

func _ready() -> void:
	path.progress_ratio = 0
	
func _process(delta: float) -> void:
	path.progress_ratio += speed * delta
	if path.progress_ratio >= 1:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage, 0, position)
	queue_free()

func change_spike_sprite():
	$Path2D/PathFollow2D/Sprite2D.visible = false
	$Path2D/PathFollow2D/Sprite2D2.visible = true
