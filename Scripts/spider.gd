extends CharacterBody2D


const WALK_SPEED = 100
var hp = 8
var damage = 1

#@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var floor_detector := $Flip/FloorDetector as RayCast2D
@onready var obsticle_detector:= $Flip/ObsticleDetector as RayCast2D
@onready var sprite := $Flip/Sprite2D as Sprite2D
@onready var playerPostion = get_parent().get_node("MainCharacter").position
@onready var flip := $Flip as Node2D
@onready var attackTimer := $AttackTimer as Timer
@onready var spawner := $Flip/PoisonSpawner as Node2D
@onready var rebound := $Rebound as Area2D

var knockback = Vector2.ZERO
var margin = 10
var range = 300
var last_direction = 0
var shoot_force = 2000

func _ready() -> void:
	#sprite_scale = sprite.scale.x
	pass

func _physics_process(delta: float) -> void:
	playerPostion = get_parent().get_node("MainCharacter").position
	velocity.y += gravity * delta
	if abs(playerPostion.y - position.y) < range:
		if floor_detector.is_colliding() and not obsticle_detector.is_colliding():
			if abs(playerPostion.x - position.x) > margin:
				last_direction = sign(playerPostion.x - position.x)
				velocity.x = WALK_SPEED * last_direction
				flip.scale.x = -last_direction
			else:
				velocity.x = 0
		elif (last_direction > 0 and playerPostion.x - position.x < -margin) or (last_direction < 0 and playerPostion.x - position.x > margin):
			velocity.x = WALK_SPEED * -last_direction
			flip.scale.x = last_direction
		else:
			velocity.x = 0
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

func _on_attack_timer_timeout():
	if abs(playerPostion.y - position.y) < range:
		var projectile = preload("res://tscn_files/poison_projectile.tscn").instantiate()
		spawner.add_child(projectile)
		projectile.apply_impulse(Vector2(last_direction, 0)*shoot_force)
		for body in rebound.get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.take_damage(damage, 5, position)


func _on_rebound_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage, 5, position)
