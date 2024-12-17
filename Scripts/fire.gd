extends Node2D

var damage = 1
@onready var timer := $Timer as Timer
@onready var area:= $Area2D as Area2D
func _process(delta: float) -> void:
	if timer.is_stopped():
		for body in area.get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.take_damage(damage, 0, position)
				timer.start()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage, 0, position)
