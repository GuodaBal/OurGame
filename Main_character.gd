extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hp = 12
@onready var animation := $AnimationPlayer as AnimationPlayer
@onready var sprite := $Sprite2D as Sprite2D
@export var attackCollision : Area2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("move_left"):
		velocity.x = -1 * SPEED
		sprite.scale.x = -1
		
	elif Input.is_action_pressed("move_right"):
		velocity.x = SPEED
		sprite.scale.x = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack(1)

	move_and_slide()

func attack(damage):
		animation.play("attack")
		for body in attackCollision.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				body.take_damage(damage)

func take_damage(damage):
	hp -= damage
	print_debug(hp)
	if hp <= 0:
		print_debug("You are dead")
		#takes to last save point