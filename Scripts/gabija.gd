extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0
const max_velocity = 300
const max_fall_velocity = 300

@onready var sprite := $Sprite2D as Sprite2D
@onready var wall_detector_left := $DetectLeft as RayCast2D
@onready var wall_detector_right := $DetectRight as RayCast2D
@onready var jump_detector_left := $JumpLeft as RayCast2D
@onready var jump_detector_right := $JumpRight as RayCast2D
@onready var jumpTimer := $JumpTimer as Timer
@onready var attackTimer := $AttackTimer as Timer
var gravityStrength = ProjectSettings.get_setting("physics/2d/default_gravity")

var gravity = Vector2(0, gravityStrength)
var gravity_dir = Vector2.DOWN
var left = Vector2(-SPEED, 0)
var right = Vector2(SPEED, 0)

var state = "down"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#velocity += gravity * delta
	velocity += gravity * delta
	# Handle jump.
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
		attackTimer.start()
	if jump_detector_right.is_colliding():
		velocity = -300 * left - 300 * gravity_dir
	if jump_detector_left.is_colliding():
		velocity = 300 * right - 300 * gravity_dir
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity = velocity.slide(gravity_dir) + gravity_dir * JUMP_VELOCITY
	if Input.is_action_just_released("ui_accept") and velocity.dot(gravity_dir) < 0.0:
		velocity = velocity.slide(gravity_dir)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if wall_detector_right.is_colliding():
		switch_gravity("left")
	if wall_detector_left.is_colliding():
		switch_gravity("right")
	#wall jump
	#if is_on_wall_only() and direction and Input.is_action_just_pressed("ui_accept"):
	#	velocity = -450.0 * direction * right_vector - 120 * gravity_dir
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if(!jumpTimer.is_stopped()):
		velocity += right * delta
	up_direction = -gravity_dir
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	velocity.y = clamp(velocity.y, -max_fall_velocity, max_fall_velocity)

	move_and_slide()

func take_damage(damage, knockback_strength, player_position):
	switch_gravity("right")

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
	
func spawn_fire_left():
	get_tree().current_scene.get_node("Level").spawn_fire_left()
func spawn_fire_right():
	get_tree().current_scene.get_node("Level").spawn_fire_right()
