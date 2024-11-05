extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = 400.0
const max_velocity = 200
const max_fall_velocity = 600
var hp = 3
var knockback = Vector2.ZERO

@onready var sprite := $Sprite2D as Sprite2D
@onready var wall_detector_left := $DetectLeft as RayCast2D
@onready var wall_detector_right := $DetectRight as RayCast2D
@onready var jump_detector_left := $JumpLeft as RayCast2D
@onready var jump_detector_right := $JumpRight as RayCast2D
@onready var jumpTimer := $JumpTimer as Timer
@onready var attackTimer := $AttackTimer as Timer
@onready var exhaustionTimer := $ExhaustionTimer as Timer
@onready var isExhaustedTimer := $IsExhaustedTimer as Timer
@onready var spikeSpawner := $SpikeSpawner as Node2D
@onready var spikeTimer := $SpikeTimer as Timer
@onready var spikeEndTimer := $SpikeEndTimer as Timer
var gravityStrength = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var playerPostion = get_parent().get_parent().get_node("MainCharacter").position
var distance_margin = 20
var range = 700


var gravity = Vector2(0, gravityStrength)
var gravity_dir = Vector2.DOWN
var left = Vector2(-SPEED, 0)
var right = Vector2(SPEED, 0)

var state = "down"
var jumping = false
var jump_direction
var will_be_exhausted = false
var attacking = false
var spawning_spikes = false

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_UP):
		switch_to_up()
	if Input.is_key_pressed(KEY_LEFT):
		switch_to_left()
	if Input.is_key_pressed(KEY_DOWN):
		switch_to_down()
	if Input.is_key_pressed(KEY_RIGHT):
		switch_to_right()
	if Input.is_key_pressed(KEY_L) and attackTimer.is_stopped():
		spawn_fire_left()
		attackTimer.start()
	if Input.is_key_pressed(KEY_K) and attackTimer.is_stopped():
		spawn_fire_right()
	if Input.is_key_pressed(KEY_J) and attackTimer.is_stopped():
		spawn_fire_bottom()
		attackTimer.start()

func _physics_process(delta: float) -> void:
	
	if will_be_exhausted and !attacking:
		will_be_exhausted = false
		switch_to_down()
		isExhaustedTimer.start()
	if spikeEndTimer.is_stopped():
			spawning_spikes = false
			attacking = false
			for spike in spikeSpawner.get_children():
				spikeSpawner.remove_child(spike)
	if spawning_spikes and spikeTimer.is_stopped():
		var instance = load("res://tscn_files/spike.tscn").instantiate()
		spikeSpawner.add_child(instance)
		instance.rotation = deg_to_rad(randf_range(-45, 45))
		spikeTimer.start()
	#gravity
	velocity += gravity * delta
	
	playerPostion = get_parent().get_parent().get_node("MainCharacter").position
	
	#jump when close enough to wall
	#falling speed needs to be faster than running speed, direction depends on gravity
	if jumping:
		velocity = JUMP_VELOCITY * jump_direction - 300 * gravity_dir
	if state == "down":
		if abs(playerPostion - position).length() > range:
			velocity.x  = lerp(velocity.x , 0.0, 0.1)
		elif !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.x - position.x > distance_margin:
				velocity += left * delta
			elif playerPostion.x - position.x < -distance_margin:
				velocity += right  * delta
		velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
		velocity.y = clamp(velocity.y, -max_fall_velocity, max_fall_velocity)
		
	elif state=="up":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
		velocity.y = clamp(velocity.y, -max_fall_velocity, max_fall_velocity)
		velocity.x  = lerp(velocity.x , 0.0, 0.1)
	
	elif state=="left":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		if abs(playerPostion - position).length() > range:
			velocity.y = lerp(velocity.y , 0.0, 0.1)
		elif !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.y - position.y > distance_margin:
				velocity += left * delta
			elif playerPostion.y - position.y < -distance_margin:
				velocity += right * delta
		velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
		velocity.x = clamp(velocity.x, -max_fall_velocity, max_fall_velocity)
	
	elif state=="right":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		if abs(playerPostion - position).length() > range:
			velocity.y = lerp(velocity.y , 0.0, 0.1)
		elif !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.y - position.y > distance_margin and !jump_detector_right.is_colliding():
				velocity += right * delta
			elif playerPostion.y - position.y < -distance_margin and !jump_detector_left.is_colliding():
				velocity += left * delta
		velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
		velocity.x = clamp(velocity.x, -max_fall_velocity, max_fall_velocity)
	#move opposite direction of player
	
	if is_on_floor() and jumpTimer.is_stopped() and isExhaustedTimer.is_stopped():
		if jump_detector_left.is_colliding() and jump_detector_left.get_collider().get_class() != "CharacterBody2D":
			jumping = true
			jumpTimer.start()
			jump_direction = left
		if jump_detector_right.is_colliding() and jump_detector_right.get_collider().get_class() != "CharacterBody2D":
			jumping = true
			jumpTimer.start()
			jump_direction = right
	

	#switch gravity when close enough to wall (after jump)
	if wall_detector_left.is_colliding() and (jumping || knockback != Vector2.ZERO and isExhaustedTimer.is_stopped()):# and wall_detector_left.get_collider().get_class() != "CharacterBody2D":
		switch_gravity("left")
		jumping = false
	if wall_detector_right.is_colliding() and (jumping || knockback != Vector2.ZERO and isExhaustedTimer.is_stopped()):# and !wall_detector_right.get_collider().get_class() != "CharacterBody2D":
		switch_gravity("right")
		jumping = false
		
	#adjust up direction for gravity to work normally
	up_direction = -gravity_dir
	#knockback MIGHT REMOVE
	velocity += knockback

	move_and_slide()

func take_damage(damage, knockback_strength, player_position):
	
	hp-=damage
	print_debug(hp)
	var direction = position - player_position
	if state == "down" or state == "up":
		knockback.x = direction.x * knockback_strength/2
		knockback.y = 0
	else:
		knockback.y = direction.y * knockback_strength/2
		knockback.x = 0
	if hp <= 0:
		#if(randi_range(0,3) == 3): #1/4 chance FOR NOW
		var instance = load("res://tscn_files/health_drop.tscn").instantiate()
		add_sibling(instance)
		instance.position = position
		queue_free()


#left or right is relative to cat rotation - converts to global
func switch_gravity(direction):
	knockback = Vector2.ZERO
	match direction:
		"left":
			match state:
				"left":
					switch_to_up()
				"right":
					switch_to_down()
				"up":
					switch_to_right()
				"down":
					switch_to_left()
		"right":
			match state:
				"left":
					switch_to_down()
				"right":
					switch_to_up()
				"up":
					switch_to_left()
				"down":
					switch_to_right()

#switches gravity (global)
func switch_to_right():
	state = "right"
	gravity_dir = Vector2.RIGHT
	gravity = Vector2(gravityStrength, 0)
	rotation = deg_to_rad(-90)
	left = Vector2(0, SPEED)
	right = Vector2(0, -SPEED)
	
func switch_to_left():
	state = "left"
	gravity_dir = Vector2.LEFT
	gravity = Vector2(-gravityStrength, 0)
	rotation = deg_to_rad(90)
	left = Vector2(0, -SPEED)
	right = Vector2(0, SPEED)

func switch_to_up():
	state = "up"
	gravity_dir = Vector2.UP
	gravity = Vector2(0, -gravityStrength)
	rotation = deg_to_rad(180)
	left = Vector2(SPEED, 0)
	right = Vector2(-SPEED, 0)

func switch_to_down():
	state = "down"
	gravity = Vector2(0, gravityStrength)
	gravity_dir = Vector2.DOWN
	rotation = deg_to_rad(0)
	left = Vector2(-SPEED, 0)
	right = Vector2(SPEED, 0)

#calls boss level to spawn fire
func spawn_fire_left():
	get_tree().current_scene.get_node("Level").spawn_fire_left()
func spawn_fire_right():
	get_tree().current_scene.get_node("Level").spawn_fire_right()
func spawn_fire_bottom():
	get_tree().current_scene.get_node("Level").spawn_fire_bottom()

#attacks depending on position
func _on_attack_timer_timeout() -> void:
	match state:
		"left":
			spawn_fire_right()
		"right":
			spawn_fire_left()
		"up":
			if randi() % 2 == 0:
				spawn_spikes()
			else:
				spawn_fire_bottom()
	if state != "down":
		attacking = true
	attackTimer.start()
	
func spawn_spikes():
	spawning_spikes = true
	spikeEndTimer.start()
func not_attacking():
	attacking = false
func _on_exhaustion_timer_timeout() -> void:
	if attacking:
		will_be_exhausted = true
	else:
		switch_to_down()
		isExhaustedTimer.start()
