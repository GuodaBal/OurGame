class_name Enemy extends CharacterBody2D


const WALK_SPEED = 30
var hp = 3

#@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var floor_detector_left := $FloorDetectorLeft as RayCast2D
@onready var floor_detector_right := $FloorDetectorRight as RayCast2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var attackTimer := $AttackTimer as Timer

@export var attackCollision : Area2D

func _physics_process(delta: float) -> void:
	if velocity.is_zero_approx():
		velocity.x = WALK_SPEED
	velocity.y += gravity * delta
	if not floor_detector_left.is_colliding():
		velocity.x = WALK_SPEED
	elif not floor_detector_right.is_colliding():
		velocity.x = -WALK_SPEED

	if is_on_wall():
		velocity.x = -velocity.x

	move_and_slide()
	if attackTimer.is_stopped():
		attack(1)
	if velocity.x > 0.0:
		sprite.scale.x = 1
	elif velocity.x < 0.0:
		sprite.scale.x = -1
		
func take_damage(damage: int):
	hp-=damage
	sprite.scale.y = -1
	if hp <= 0:
		queue_free()
		
func attack(damage):
		#animation.play("attack")
		for body in attackCollision.get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.take_damage(damage)
				attackTimer.start()
