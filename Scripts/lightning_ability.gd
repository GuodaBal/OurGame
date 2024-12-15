extends Area2D

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
var damage
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("spawn")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		body.take_damage(damage, 5 ,position)


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
