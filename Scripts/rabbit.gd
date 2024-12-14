extends CharacterBody2D


const WALK_SPEED = 450
const JUMP_STRENGTH = -600

var hp = 15
var damage = 1

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var floor_detector := $AnimatedSprite2D/FloorDetector as RayCast2D
@onready var obsticle_detector:= $AnimatedSprite2D/ObstacleDetector as RayCast2D
@onready var attackTimer := $AttackTimer as Timer
@onready var attackArea := $HitArea as Area2D
@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var switchTimer := $SwitchDirections as Timer #Rabbit randomly switches directions
@onready var stuckTimer := $StuckTimer as Timer  #Used for checking if obsticle detector keeps colliding with something for a
#long time, indicating rabbit is stuck
var knockback = Vector2.ZERO
var sprite_scale
var direction = -1

var state = "running"

func _ready() -> void:
	sprite_scale = animation.scale.x
	animation.play("running")

func _physics_process(delta: float) -> void:
	if state == "jumping" and is_on_floor():
		state = "running"
	if state == "running" and ((obsticle_detector.is_colliding() and is_on_floor()) or !floor_detector.is_colliding()):
		velocity.y = JUMP_STRENGTH
		state = "jumping"
	velocity.y += gravity * delta
	
	velocity.x = WALK_SPEED * direction
	animation.scale.x = -direction * sprite_scale
	#Using timer to see if rabbit keeps colliding with wall for set amount of time
	if obsticle_detector.is_colliding():
		if stuckTimer.is_stopped():
			stuckTimer.start()
	else:
		stuckTimer.stop()
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
		animation.play("death")
		await animation.animation_finished
		queue_free()
		
func attack(body):
	animation.play("attack")
	body.take_damage(damage, 3, position)
	attackTimer.start()

func _on_attack_timer_timeout():
	for body in attackArea.get_overlapping_bodies():
		if body.is_in_group("Player"):
			attack(body)


func _on_hit_area_body_entered(body: Node2D) -> void:
	if attackTimer.is_stopped() && body.is_in_group("Player"):
		attack(body)


func _on_switch_directions_timeout() -> void:
	
	direction *= -1
	switchTimer.start(randi_range(6, 15))
	

func _on_stuck_timer_timeout() -> void:
	direction *= -1
	switchTimer.start(randi_range(6, 15))
