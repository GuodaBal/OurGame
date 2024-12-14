extends CharacterBody2D


const WALK_SPEED = 140
var hp = 20
var damage = 1

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var floor_detector := $Flip/FloorDetector as RayCast2D
@onready var obsticle_detector:= $Flip/ObstacleDetector as RayCast2D
@onready var playerPosition = get_parent().get_node("MainCharacter").position
@onready var flip := $Flip as Node2D #Node that flips sprite and raycasts
@onready var attackTimer := $AttackTimer as Timer
@onready var attackArea := $Flip/Attack as Area2D
@onready var rebound := $Rebound as Area2D #Stops player from standing on it
@onready var animation := $Flip/AnimatedSprite2D as AnimatedSprite2D

var knockback = Vector2.ZERO
var sprite_scale
var margin = 10
var range = 650
var last_direction = 0

func _physics_process(delta: float) -> void:
	if animation.is_playing() and animation.get_animation() == "attack":
		velocity.x = 0
	else:
		playerPosition = get_parent().get_node("MainCharacter").position
		velocity.y += gravity * delta
		if (playerPosition - position).length() < range and floor_detector.is_colliding() and not obsticle_detector.is_colliding():
			if abs(playerPosition.x - position.x) > margin:
				last_direction = sign(playerPosition.x - position.x)
				velocity.x = WALK_SPEED * last_direction
				flip.scale.x = -last_direction
			else:
				velocity.x = 0
		#If can't move forward and player is in opposite direction, flip
		elif (last_direction > 0 and playerPosition.x - position.x < -margin) or (last_direction < 0 and playerPosition.x - position.x > margin):
			velocity.x = WALK_SPEED * -last_direction
			flip.scale.x = last_direction
		else:
			velocity.x = 0
	velocity += knockback
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)

	
func take_damage(damage: int, knockback_strength: int, character_position: Vector2):
	hp-=damage
	var direction = position - character_position
	knockback = direction * knockback_strength
	knockback.y = 0
	if hp <= 0:
		if(randi_range(0,3) == 3): #1/4 chance FOR NOW
			var instance = load("res://tscn_files/health_drop.tscn").instantiate()
			add_sibling(instance)
			instance.position = position
		queue_free()
		
func attack(body):
	animation.play("attack")
	body.take_damage(damage, 3, position)
	attackTimer.start()

func _on_attack_body_entered(body):
	if attackTimer.is_stopped() && body.is_in_group("Player"):
		attack(body)
		
func _on_attack_timer_timeout():
	for body in attackArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			attack(body)
