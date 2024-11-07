extends CharacterBody2D


const FLY_SPEED = 100.0
var hp = 3
var damage = 1

#@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var sprite := $Sprite2D as Sprite2D
@onready var attackTimer := $AttackTimer as Timer
@onready var playerPostion = get_parent().get_parent().get_node("MainCharacter").position
@onready var obsDetectorLeft := $ObstacleDetectorLeft as Area2D
@onready var obsDetectorRight := $ObstacleDetectorRight as Area2D
@onready var flyHeight := $FlyHeight as RayCast2D

@onready var attackArea := $AttackArea as Area2D

var knockback = Vector2.ZERO

var y_hover_offset = 0.0

# Smoothing factor for lerp-based transitions
const SMOOTHING_FACTOR = 0.5
var movement_cooldown = 0.0
const COOLDOWN_TIME = 0.2  # Cooldown before

func _physics_process(delta: float) -> void:

	playerPostion = get_parent().get_parent().get_node("MainCharacter").position
	
	movement_cooldown -= delta  # Update cooldown timer
		# Add a hover effect to make movement less robotic
	y_hover_offset = sin(Time.get_ticks_msec() / 1000.0) * 5.0
	if movement_cooldown <= 0.0:
		if !obsDetectorLeft.get_overlapping_bodies().is_empty():
			velocity.y = lerp(velocity.y, -FLY_SPEED + y_hover_offset, SMOOTHING_FACTOR)
			movement_cooldown = COOLDOWN_TIME
		elif !obsDetectorRight.get_overlapping_bodies().is_empty():
			velocity.y = lerp(velocity.y, -FLY_SPEED + y_hover_offset, SMOOTHING_FACTOR)
			movement_cooldown = COOLDOWN_TIME
		elif flyHeight.is_colliding() and flyHeight.get_collider().get_class() != "CharacterBody2D":
			velocity.y = lerp(velocity.y, -FLY_SPEED + y_hover_offset, SMOOTHING_FACTOR)
			movement_cooldown = COOLDOWN_TIME
		elif position.y  - playerPostion.y < -100:
			velocity.y = lerp(velocity.y, FLY_SPEED + y_hover_offset, SMOOTHING_FACTOR)
			movement_cooldown = COOLDOWN_TIME
		else:
			velocity.y = lerp(velocity.y, y_hover_offset, SMOOTHING_FACTOR)
		if playerPostion.x - position.x > 5:
			velocity.x = FLY_SPEED
		elif playerPostion.x - position.x < -5:
			velocity.x = -FLY_SPEED
		else:
			velocity.x = 0
		
	velocity += knockback


	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	
	if velocity.x > 0:
		#print_debug(velocity.x)
		sprite.scale.x = -0.1
	elif velocity.x < 0:
#		print_debug(velocity.x)
		sprite.scale.x = 0.1
		
func take_damage(damage: int, knockback_strength: int, character_position: Vector2):
	hp-=damage
	var direction = position - character_position
	knockback = direction.normalized() * knockback_strength*50
	#knockback = lerp(knockback, Vector2.ZERO, 0.1)
	sprite.scale.y = -0.1
	if hp <= 0:
		#if(randi_range(0,3) == 3): #1/4 chance FOR NOW
		var instance = load("res://tscn_files/health_drop.tscn").instantiate()
		add_sibling(instance)
		instance.position = position
		queue_free()
		
func attack(body):
	body.take_damage(damage, 5, position)
	attackTimer.start()

func _on_attack_body_entered(body):
	if attackTimer.is_stopped() && body.is_in_group("Player"):
		attack(body)
		
func _on_attack_timer_timeout():
	for body in attackArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			attack(body)
