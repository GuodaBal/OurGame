extends CharacterBody2D


const WALK_SPEED = 100
var hp = 8
var damage = 1

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var floor_detector := $Flip/FloorDetector as RayCast2D
@onready var obsticle_detector:= $Flip/ObsticleDetector as RayCast2D
@onready var playerPosition = get_parent().get_node("MainCharacter").position
@onready var flip := $Flip as Node2D #Node that flips sprite and raycasts
@onready var attackTimer := $AttackTimer as Timer #How often it shoots the projectile
@onready var spawner := $Flip/PoisonSpawner as Node2D #Projectile spawn position
@onready var rebound := $Rebound as Area2D #Stops player from standing on it
@onready var animation := $Flip/AnimatedSprite2D as AnimatedSprite2D
@onready var audio = $Attack
@onready var audio2 = $TakeDamage
var knockback = Vector2.ZERO
var margin = 100 #How far away the player has to be to follow
var range = 300 #Range to start following player
var last_direction = 0
var shoot_force = 1000

func _physics_process(delta: float) -> void:
	playerPosition = get_parent().get_node("MainCharacter").position
	velocity.y += gravity * delta
	if abs(playerPosition.y - position.y) < range and floor_detector.is_colliding() and not obsticle_detector.is_colliding():
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
		
	if velocity.x == 0 and hp > 0:
		animation.play("standing") 
	elif !(animation.is_playing() and animation.animation == "running") and hp > 0:
		animation.play("running") 
	velocity += knockback
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)

func take_damage(damage: int, knockback_strength: int, character_position: Vector2):
	AudioManager.play_with_random_pitch(audio2)
	hp-=damage
	var direction = position - character_position
	knockback = direction * knockback_strength
	knockback.y = 0
	if hp <= 0:
		if(randi_range(0,3) == 3): #1/4 chance FOR NOW
			var instance = load("res://tscn_files/health_drop.tscn").instantiate()
			add_sibling(instance)
			instance.position = position
		animation.play("death")
		await animation.animation_finished
		queue_free()

func _on_attack_timer_timeout():
	#shoots poison projectile
	if (playerPosition - position).length() < range:
		AudioManager.play_with_random_pitch(audio)
		var projectile = preload("res://tscn_files/poison_projectile.tscn").instantiate()
		spawner.add_child(projectile)
		projectile.apply_impulse(Vector2(last_direction, -0.3)*shoot_force)
		#Guarantees player cannot stand on enemy without taking damage
		for body in rebound.get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.take_damage(damage, 5, position)

#Guarantees player cannot stand on enemy without taking damage
func _on_rebound_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage, 5, position)
