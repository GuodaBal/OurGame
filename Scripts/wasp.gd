extends CharacterBody2D


const SPEED_WANDER = 95.0
const SPEED_FOLLOW = 140.0
var current_speed
var hp = 6
var damage = 1

#@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var attackTimer := $AttackTimer as Timer #Time between attacks
@onready var playerPosition = get_parent().get_node("MainCharacter").position
@onready var attackArea := $AttackArea as Area2D
@onready var navigation := $NavigationAgent2D as NavigationAgent2D
@onready var spawner := $SpikeSpawner as Node2D

var knockback = Vector2.ZERO
var sprite_scale

var attackRange = 400
var range = 800


func _ready() -> void:
	sprite_scale = animation.scale.x
	var rndpos = Vector2(position.x + randf_range(-200, 200), position.y + randf_range(-100, 100)) 
	navigation.target_position = rndpos
	current_speed = SPEED_WANDER


func _physics_process(delta: float) -> void:
	playerPosition = get_parent().get_node("MainCharacter").position
	playerPosition.y-=150
	playerPosition.x+=10
	
	if (animation.is_playing() and animation.animation == "attack") or  abs((position - navigation.target_position).length()) < 10:
		velocity = Vector2(0,0)
	else:
		var dir = position.direction_to(navigation.get_next_path_position()).normalized()
		velocity = dir * current_speed + knockback
		if dir.x > 0.2:
			animation.scale.x = -sprite_scale
		elif dir.x < -0.2:
			animation.scale.x = sprite_scale
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)

func take_damage(damage: int, knockback_strength: int, character_position: Vector2):
	hp-=damage
	var direction = position - character_position
	knockback = direction.normalized() * knockback_strength*200
	if hp <= 0:
		if(randi_range(0,3) == 3): #1/4 chance FOR NOW
			var instance = load("res://tscn_files/health_drop.tscn").instantiate()
			add_sibling(instance)
			instance.position = position
		queue_free()
		
func attack(body):
	body.take_damage(damage, 5, position)
	
func _on_attack_timer_timeout():
	if (playerPosition - position).length() < attackRange:
		var spike = preload("res://tscn_files/spike.tscn").instantiate()
		spawner.add_child(spike)
		#The position used for navigation is different from the real character position
		var charPosition = get_parent().get_node("MainCharacter").position
		charPosition.y -= 50
		spike.rotation = position.angle_to_point(charPosition) + deg_to_rad(90)
		spike.scale = Vector2(0.2, 0.2)
		spike.speed = 0.5
		animation.play("attack")
	attackTimer.start()
	
	
func _on_update_target_timeout() -> void:
	if (position - playerPosition).length() < range:
		navigation.target_position = playerPosition
		current_speed = SPEED_FOLLOW
	#Checks if previous target has been reached, or if the wasp has stopped (gotten stuck in a corner)
	elif (position - navigation.target_position).length() < attackRange || get_real_velocity().length() < 6:
		var rndpos = Vector2(position.x + randf_range(-500, 500), position.y + randf_range(-500, 500)) 
		navigation.target_position = rndpos
		current_speed = SPEED_WANDER
	


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attack(body)
		attackTimer.start()
