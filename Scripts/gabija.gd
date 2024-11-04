extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0
const max_velocity = 200
const max_fall_velocity = 400

@onready var sprite := $Sprite2D as Sprite2D
@onready var wall_detector_left := $DetectLeft as RayCast2D
@onready var wall_detector_right := $DetectRight as RayCast2D
@onready var jump_detector_left := $JumpLeft as RayCast2D
@onready var jump_detector_right := $JumpRight as RayCast2D
@onready var jumpTimer := $JumpTimer as Timer
@onready var attackTimer := $AttackTimer as Timer
@onready var exhaustionTimer := $ExhaustionTimer as Timer
@onready var isExhaustedTimer := $IsExhaustedTimer as Timer
var gravityStrength = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var playerPostion = get_parent().get_parent().get_node("MainCharacter").position
var distance_margin = 20

var gravity = Vector2(0, gravityStrength)
var gravity_dir = Vector2.DOWN
var left = Vector2(-SPEED, 0)
var right = Vector2(SPEED, 0)

var state = "down"
var jumping = false
var jump_direction

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
	
	#gravity
	velocity += gravity * delta
	
	playerPostion = get_parent().get_parent().get_node("MainCharacter").position
	
	#jump when close enough to wall
	#falling speed needs to be faster than running speed, direction depends on gravity
	
	if state == "down":
		if !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
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
		if !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.y - position.y > distance_margin:
				velocity += left * delta
			elif playerPostion.y - position.y < -distance_margin:
				velocity += right * delta
		velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
		velocity.x = clamp(velocity.x, -max_fall_velocity, max_fall_velocity)
	
	elif state=="right":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		if !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.y - position.y > distance_margin and !jump_detector_right.is_colliding():
				velocity += right * delta
			elif playerPostion.y - position.y < -distance_margin and !jump_detector_left.is_colliding():
				velocity += left * delta
		var new_velocity_y := clamp(velocity.y, -max_velocity, max_velocity) as float
		var new_velocity_x := clamp(velocity.x, -max_fall_velocity, max_fall_velocity) as float
		velocity.y = lerp(velocity.y, new_velocity_y, 0.1)
		velocity.x = lerp(velocity.x, new_velocity_x, 0.1)
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
	
	if jumping:
		velocity = 300 * jump_direction - 300 * gravity_dir
	#switch gravity when close enough to wall (after jump)
	if wall_detector_left.is_colliding() and jumping:# and wall_detector_left.get_collider().get_class() != "CharacterBody2D":
		print_debug(wall_detector_left.get_collider())
		print_debug(wall_detector_left.get_collider().get_parent())
		switch_gravity("left")
		jumping = false
	if wall_detector_right.is_colliding() and jumping:# and !wall_detector_right.get_collider().get_class() != "CharacterBody2D":
		switch_gravity("right")
		jumping = false
	
	velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
	velocity.x = clamp(velocity.x, -max_fall_velocity, max_fall_velocity)
	#TEMP moving 
	#if(!jumpTimer.is_stopped()):
	#velocity += right * delta
	
	#adjust up direction for gravity to work normally
	up_direction = -gravity_dir


		
	move_and_slide()

func take_damage(damage, knockback_strength, player_position):
	switch_gravity("right")


#left or right is relative to cat rotation - converts to global
func switch_gravity(direction):
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
			spawn_fire_bottom()
	attackTimer.start()


func _on_exhaustion_timer_timeout() -> void:
	switch_to_down()
	isExhaustedTimer.start()
