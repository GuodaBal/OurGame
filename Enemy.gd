class_name Enemy extends CharacterBody2D


const WALK_SPEED = 50
var hp = 3
var damage = 1

#@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var floor_detector_left := $FloorDetectorLeft as RayCast2D
@onready var floor_detector_right := $FloorDetectorRight as RayCast2D
@onready var obsticle_detector_left := $ObsticleDetectorLeft as RayCast2D
@onready var obsticle_detector_right := $ObsticleDetectorRight as RayCast2D
@onready var sprite := $Sprite2D as Sprite2D
@onready var attackTimer := $AttackTimer as Timer
@onready var playerPostion = get_parent().get_node("Main_character").position

@export var attackArea: Area2D

func _physics_process(delta: float) -> void:
	#if velocity.is_zero_approx():
	#	velocity.x = WALK_SPEED
	playerPostion = get_parent().get_node("Main_character").position
	velocity.y += gravity * delta
	if playerPostion.x - position.x > 0.4 and floor_detector_right.is_colliding() and not obsticle_detector_right.is_colliding():
		velocity.x = WALK_SPEED
	elif playerPostion.x - position.x < -0.4 and floor_detector_left.is_colliding() and not obsticle_detector_left.is_colliding():
		velocity.x = -WALK_SPEED
	else:
		velocity.x = 0
		
	

	if is_on_wall():
		velocity.x = -velocity.x

	move_and_slide()
	
	if velocity.x > 0:
		#print_debug(velocity.x)
		sprite.scale.x = -1
	elif velocity.x < 0:
#		print_debug(velocity.x)
		sprite.scale.x = 1
		
func take_damage(damage: int):
	hp-=damage
	sprite.scale.y = -1
	if hp <= 0:
		queue_free()
		
func attack(body):
	body.take_damage(damage)
	attackTimer.start()

func _on_attack_body_entered(body):
	if attackTimer.is_stopped() && body.is_in_group("Player"):
		attack(body)
		


func _on_attack_timer_timeout():
	for body in attackArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			attack(body)
