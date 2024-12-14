extends CharacterBody2D

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
var SPEED = 400.0
var direction = 1

func _ready() -> void:
	animation.play("running")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	if get_real_velocity().length() < 5:
		queue_free()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(1, 1, position)
