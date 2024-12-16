extends CharacterBody2D


const SPEED_WANDER = 100.0
const SPEED_FOLLOW = 150.0
const SPEED_ATTACK = 200.0
var current_speed
var hp = 6
var damage = 1

#@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var attackTimer := $AttackTimer as Timer #Time between attacks
@onready var playerPosition = get_parent().get_node("MainCharacter").position
@onready var attackArea := $AttackArea as Area2D
@onready var navigation := $NavigationAgent2D as NavigationAgent2D
@onready var audio = $Bite
@onready var audio2 = $TakeDamage
var knockback = Vector2.ZERO
var sprite_scale

var attackRange = 200
var range = 600
var attacking = false

func _ready() -> void:
	sprite_scale = animation.scale.x
	var rndpos = Vector2(position.x + randf_range(-200, 200), position.y + randf_range(-100, 100)) 
	navigation.target_position = rndpos
	current_speed = SPEED_WANDER
	animation.play("flying")


func _physics_process(delta: float) -> void:

	playerPosition = get_parent().get_node("MainCharacter").position
	playerPosition.y-=30
	playerPosition.x+=10
	
	if (position - playerPosition).length() < attackRange && attackTimer.is_stopped():
		current_speed = SPEED_ATTACK
		attacking = true
	var dir = position.direction_to(navigation.get_next_path_position()).normalized()
	velocity = dir * current_speed + knockback
	if dir.x > 0.2:
		animation.scale.x = -sprite_scale
	elif dir.x < -0.2:
		animation.scale.x = sprite_scale
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)

func take_damage(damage: int, knockback_strength: int, character_position: Vector2):
	AudioManager.play_with_random_pitch(audio2)
	hp-=damage
	var direction = position - character_position
	knockback = direction.normalized() * knockback_strength*200
	if hp <= 0:
		die()
		
func attack(body):
	attacking = false
	AudioManager.play_with_random_pitch(audio)
	body.take_damage(damage, 5, position)
	attackTimer.start()

func _on_attack_body_entered(body):
	if attackTimer.is_stopped() && body.is_in_group("Player"):
		attack(body)
		
func _on_attack_timer_timeout():
	for body in attackArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			attack(body)
			
func _on_update_target_timeout() -> void:
	if !attacking:
		if (position - playerPosition).length() < range && attackTimer.is_stopped():
			navigation.target_position = playerPosition
			current_speed = SPEED_FOLLOW
		#Checks if previous target has been reached, or if the bat has stopped (gotten stuck in a corner)
		elif abs((position - navigation.target_position).length()) < attackRange || get_real_velocity().length() < 6:
			var rndpos = Vector2(position.x + randf_range(-500, 500), position.y + randf_range(-500, 500)) 
			navigation.target_position = rndpos
			current_speed = SPEED_WANDER
	else:
		navigation.target_position = playerPosition
	
func die():
	if(randi_range(0,3) == 3):
		var instance = load("res://tscn_files/health_drop.tscn").instantiate()
		add_sibling(instance)
		instance.position = position
	animation.play("death")
	await animation.animation_finished
	queue_free()

func _on_navigation_agent_2d_target_reached() -> void:
	attacking = false
