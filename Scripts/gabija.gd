extends CharacterBody2D


const SPEED = 500
const JUMP_VELOCITY = 1500.0
const max_velocity = 350
const max_fall_velocity = 600
var hp = 40

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
@onready var jumpEndTimer := $JumpEndTimer as Timer
var gravityStrength = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var playerPostion = get_parent().get_parent().get_node("MainCharacter").position
var distance_margin = 20
var range = 1000


var gravity = Vector2(0, gravityStrength)
var gravity_dir = Vector2.DOWN
var left = Vector2(-SPEED, 0)
var right = Vector2(SPEED, 0)

var state = "down"
var jumping = false
var jump_direction
var will_be_exhausted = false
var attacking := [] as Array
var spawning_spikes = false

var sprite_scale

func _ready() -> void:
	sprite_scale = sprite.scale.x

func _physics_process(delta: float) -> void:
	#If it's falling after becoming exhausted, it falls to the opposite direction of the player, so as to not land on them
	if !isExhaustedTimer.is_stopped() and !is_on_floor():
		if player_is_to("right") and !wall_detector_left.is_colliding():
			velocity += left * delta
			sprite.scale.x = -sprite_scale
		elif player_is_to("left") and !wall_detector_right.is_colliding():
			velocity += right  * delta
			sprite.scale.x = sprite_scale
	#If it's exhausted and on the floor, stops moving
	if !isExhaustedTimer.is_stopped() and is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, 0.1)

	if will_be_exhausted and attacking.is_empty():
		will_be_exhausted = false
		switch_to_down()
		isExhaustedTimer.start()
	velocity += gravity * delta
	
	playerPostion = get_parent().get_parent().get_node("MainCharacter").position
	
	#jump when close enough to wall
	#falling speed needs to be faster than running speed, direction depends on gravity
	if jumping:
		velocity = JUMP_VELOCITY * jump_direction - 500 * gravity_dir
	
	#slow down to stop when attacking
	if !attacking.is_empty():
		velocity.x  = lerp(velocity.x , 0.0, 0.1)
		velocity.y  = lerp(velocity.y , 0.0, 0.1)
	elif state=="up":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		if position.x > 1200 and !jump_detector_right.is_colliding():
			velocity += right * delta
			sprite.scale.x = sprite_scale
		elif position.x < 750 and !jump_detector_left.is_colliding():
			velocity += left * delta
			sprite.scale.x = -sprite_scale
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.05)
	#move opposite direction of player

	else:
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		elif !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if player_is_to("left") and !jump_detector_right.is_colliding():
				velocity += right * delta
				sprite.scale.x = sprite_scale
			elif player_is_to("right") and !jump_detector_left.is_colliding():
				velocity += left * delta
				sprite.scale.x = -sprite_scale
			else:
				if state == "down":
					velocity.x = lerp(velocity.x , 0.0, 0.1)
				else:
					velocity.y = lerp(velocity.y , 0.0, 0.1)
	if state == "down" or state == "up":
		velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
		velocity.y = clamp(velocity.y, -max_fall_velocity, max_fall_velocity)
	else:
		velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
		velocity.x = clamp(velocity.x, -max_fall_velocity, max_fall_velocity)
	#jumping
	if is_on_floor() and jumpTimer.is_stopped() and isExhaustedTimer.is_stopped():
		if jump_detector_left.is_colliding() and jump_detector_left.get_collider() is TileMapLayer and player_is_to("right") and attacking.is_empty():
			var tile_data=jump_detector_left.get_collider().get_cell_tile_data(jump_detector_left.get_collider().get_coords_for_body_rid(jump_detector_left.get_collider_rid()))
			if tile_data.get_custom_data_by_layer_id(0)==1:
				jumping = true
				jumpTimer.start()
				jumpEndTimer.start()
				jump_direction = left
				sprite.scale.x = -sprite_scale
		if jump_detector_right.is_colliding() and jump_detector_right.get_collider() is TileMapLayer and player_is_to("left") and attacking.is_empty():
			var tile_data=jump_detector_right.get_collider().get_cell_tile_data(jump_detector_right.get_collider().get_coords_for_body_rid(jump_detector_right.get_collider_rid()))
			if tile_data.get_custom_data_by_layer_id(0)==1:
				jumping = true
				jumpTimer.start()
				jumpEndTimer.start()
				jump_direction = right
				sprite.scale.x = sprite_scale
				
	#switch gravity when close enough to wall (after jump)
	if wall_detector_left.is_colliding() and wall_detector_left.get_collider() is TileMapLayer and jumping:# and wall_detector_left.get_collider().get_class() != "CharacterBody2D":
		var tile_data=wall_detector_left.get_collider().get_cell_tile_data(wall_detector_left.get_collider().get_coords_for_body_rid(wall_detector_left.get_collider_rid()))
		if tile_data.get_custom_data_by_layer_id(1)==1:
			switch_gravity("left")
			sprite.scale.x = -sprite_scale
	if wall_detector_right.is_colliding() and wall_detector_right.get_collider() is TileMapLayer and jumping:# and !wall_detector_right.get_collider().get_class() != "CharacterBody2D":
		var tile_data=wall_detector_right.get_collider().get_cell_tile_data(wall_detector_right.get_collider().get_coords_for_body_rid(wall_detector_right.get_collider_rid()))
		if tile_data.get_custom_data_by_layer_id(1)==1:
			switch_gravity("right")
			sprite.scale.x = sprite_scale
		
	#adjust up direction for gravity to work normally
	up_direction = -gravity_dir
	
	move_and_slide()

func take_damage(damage, knockback_strength, player_position):
	hp-=damage
	print_debug(hp)
	var direction = position - player_position
	if hp <= 0:
		GlobalVariables.GabijaDone = true
		for child in get_tree().current_scene.get_children():
			if "Level" in child.name:
				child.switch_scene()
		var instance = load("res://tscn_files/health_drop.tscn").instantiate()
		add_sibling(instance)
		instance.position = position
		queue_free()

#left or right is relative to cat rotation - converts to global
func switch_gravity(direction):
	jumping = false
	match [direction, state]:
		["left", "left"]:
			switch_to_up()
		["left", "right"]:
			switch_to_down()
		["left", "up"]:
			switch_to_right()
		["left", "down"]:
			switch_to_left()
		["right", "left"]:
			switch_to_down()
		["right", "right"]:
			switch_to_up()
		["right", "up"]:
			switch_to_left()
		["right", "down"]:
			switch_to_right()

#switches gravity (global)
func switch_to_right():
	print_debug("switched to right")
	state = "right"
	gravity_dir = Vector2.RIGHT
	gravity = Vector2(gravityStrength, 0)
	rotation = deg_to_rad(-90)
	left = Vector2(0, SPEED)
	right = Vector2(0, -SPEED)
	
func switch_to_left():
	print_debug("switched to left")
	state = "left"
	gravity_dir = Vector2.LEFT
	gravity = Vector2(-gravityStrength, 0)
	rotation = deg_to_rad(90)
	left = Vector2(0, -SPEED)
	right = Vector2(0, SPEED)

func switch_to_up():
	print_debug("switched to up")
	state = "up"
	gravity_dir = Vector2.UP
	gravity = Vector2(0, -gravityStrength)
	rotation = deg_to_rad(180)
	left = Vector2(SPEED, 0)
	right = Vector2(-SPEED, 0)

func switch_to_down():
	print_debug("switched to down")
	state = "down"
	gravity = Vector2(0, gravityStrength)
	gravity_dir = Vector2.DOWN
	rotation = deg_to_rad(0)
	left = Vector2(-SPEED, 0)
	right = Vector2(SPEED, 0)

#calls boss level to spawn fire
func spawn_fire_left():
	for child in get_tree().current_scene.get_children():
		if "Level" in child.name:
			child.spawn_fire_left()
func spawn_fire_right():
	for child in get_tree().current_scene.get_children():
		if "Level" in child.name:
			child.spawn_fire_right()
func spawn_fire_bottom():
	for child in get_tree().current_scene.get_children():
		if "Level" in child.name:
			child.spawn_fire_bottom()

#attacks depending on position
func _on_attack_timer_timeout() -> void:
	if isExhaustedTimer.is_stopped() and !will_be_exhausted and is_on_floor():
		match state:
			"left":
				spawn_fire_right()
			"right":
				spawn_fire_left()
			"up":
				if playerPostion.x > 1600:
					spawn_fire_right()
				elif playerPostion.x < 200:
					spawn_fire_right()
				elif randi() % 2 == 0:
					spawn_spikes()
				else:	
					spawn_fire_bottom()
		if state != "down":
			attacking.append(0)
	attackTimer.start()
	
func spawn_spikes():
	spawning_spikes = true
	spikeEndTimer.start()
	spikeTimer.start()
	
func not_attacking():
	attacking.pop_back()

func _on_exhaustion_timer_timeout() -> void:
	if !attacking.is_empty():
		will_be_exhausted = true
		print_debug("will be exhausted")
	else:
		print_debug("down from timer")
		switch_to_down()
		isExhaustedTimer.start()


func _on_spike_end_timer_timeout() -> void:
	spawning_spikes = false
	attacking.pop_back()
	if will_be_exhausted:
		will_be_exhausted = false
		switch_to_down()
		isExhaustedTimer.start()

func _on_jump_end_timer_timeout() -> void:
	jumping = false
	
func player_is_to(direction: String):
	if abs(playerPostion - position).length() > range:
		return false
	match [direction, state]:
		["left", "down"]:
			if playerPostion.x - position.x <= -distance_margin:
				return true 
		["left", "up"]:
			if playerPostion.x - position.x >= distance_margin:
				return true 
		["left", "left"]:
			if playerPostion.y - position.y <= -distance_margin:
				return true 
		["left", "right"]:
			if playerPostion.y - position.y >= distance_margin:
				return true 
		["right", "down"]:
			if playerPostion.x - position.x >= distance_margin:
				return true 
		["right", "up"]:
			if playerPostion.x - position.x <= -distance_margin:
				return true 
		["right", "left"]:
			if playerPostion.y - position.y >= distance_margin:
				return true 
		["right", "right"]:
			if playerPostion.y - position.y <= -distance_margin:
				return true 
	return false

#damage + knockback if player jumps on 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and state == "down":
		body.take_damage(1, 10, position)

func _on_spike_timer_timeout() -> void:
	if spawning_spikes and !spikeEndTimer.is_stopped() and isExhaustedTimer.is_stopped() and is_on_floor():
		for rot in range(-70, 71, 10):
			var instance = load("res://tscn_files/spike.tscn").instantiate()
			spikeSpawner.add_child(instance)
			instance.rotation = deg_to_rad(rot)
		spikeTimer.start()
