extends CharacterBody2D


const SPEED = 500
const JUMP_VELOCITY = 1500.0
const max_velocity = 350
const max_fall_velocity = 600
var hp = 40
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
@onready var jumpEndTimer := $JumpEndTimer as Timer
@onready var attackBufferTimer := $AttackBufferTimer as Timer
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
	if !isExhaustedTimer.is_stopped() and !is_on_floor():
		if playerPostion.x - position.x > distance_margin and !wall_detector_left.is_colliding():
			velocity += left * delta
			sprite.scale.x = -sprite_scale
			#print_debug("g")
		elif playerPostion.x - position.x < -distance_margin and !wall_detector_right.is_colliding():
			velocity += right  * delta
			sprite.scale.x = sprite_scale
			#print_debug("h")
	if !isExhaustedTimer.is_stopped() and is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, 0.1)
	if jumpEndTimer.is_stopped() and is_on_floor():
		jumping = false

	if will_be_exhausted and attacking.is_empty() and attackBufferTimer.is_stopped() and spawning_spikes:
		#print_debug("start_attack_buffer")
		attackBufferTimer.start()
		spawning_spikes = false
	#if will_be_exhausted and attacking.is_empty() and attackBufferTimer.is_stopped() and !spawning_spikes:
	#	#print_debug("stopped attacking is exhausted")
	#	will_be_exhausted = false
	#	switch_to_down()
	#	isExhaustedTimer.start()
	#if spawning_spikes and !spikeEndTimer.is_stopped() and spikeTimer.is_stopped() and isExhaustedTimer.is_stopped() and is_on_floor():
		#print_debug(spawning_spikes)
		#print_debug("c")
	#	var instance = load("res://tscn_files/spike.tscn").instantiate()
	#	spikeSpawner.add_child(instance)
	#	instance.rotation = deg_to_rad(randf_range(-70, 70))
	#	spikeTimer.start()
		#print_debug("a")
	#gravity
	velocity += gravity * delta
	
	playerPostion = get_parent().get_parent().get_node("MainCharacter").position
	
	#jump when close enough to wall
	#falling speed needs to be faster than running speed, direction depends on gravity
	if jumping:
		#print_debug("d")
		velocity = JUMP_VELOCITY * jump_direction - 500 * gravity_dir

	if !attacking.is_empty():
		#print_debug("e")
		velocity.x  = lerp(velocity.x , 0.0, 0.1)
		velocity.y  = lerp(velocity.y , 0.0, 0.1)
	elif state == "down":
		if abs(playerPostion - position).length() > range:
			velocity.x  = lerp(velocity.x , 0.0, 0.1)
		elif !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.x - position.x > distance_margin and !jump_detector_left.is_colliding():
				velocity += left * delta
				sprite.scale.x = -sprite_scale
				#print_debug("g")
			elif playerPostion.x - position.x < -distance_margin and !jump_detector_right.is_colliding():
				velocity += right * delta
				sprite.scale.x = sprite_scale
				#print_debug("h")
		velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
		velocity.y = clamp(velocity.y, -max_fall_velocity, max_fall_velocity)
		
	elif state=="up":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		if position.x > 1300 and !jump_detector_right.is_colliding():
			#print_debug("k")
			velocity += right * delta
			sprite.scale.x = sprite_scale
		elif position.x < 650 and !jump_detector_left.is_colliding():
			#print_debug("l")
			velocity += left * delta
			sprite.scale.x = -sprite_scale
		velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
		velocity.y = clamp(velocity.y, -max_fall_velocity, max_fall_velocity)
		#velocity.x  = lerp(velocity.x , 0.0, 0.1)
	
	elif state=="left":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		if abs(playerPostion - position).length() > range:
			velocity.y = lerp(velocity.y , 0.0, 0.1)
			#print_debug("m")
		elif !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.y - position.y > distance_margin and !jump_detector_left.is_colliding():
				velocity += left * delta
				sprite.scale.x = -sprite_scale
				#print_debug("n")
			elif playerPostion.y - position.y < -distance_margin and !jump_detector_right.is_colliding():
				velocity += right * delta
				sprite.scale.x = sprite_scale
				#print_debug("o")
			else:
				velocity.y = lerp(velocity.y , 0.0, 0.1)
		velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
		velocity.x = clamp(velocity.x, -max_fall_velocity, max_fall_velocity)
	
	elif state=="right":
		if exhaustionTimer.is_stopped():
			exhaustionTimer.start()
		if abs(playerPostion - position).length() > range:
			velocity.y = lerp(velocity.y , 0.0, 0.1)
			#print_debug("p")
		elif !jumping and isExhaustedTimer.is_stopped() and is_on_floor():
			if playerPostion.y - position.y > distance_margin and !jump_detector_right.is_colliding():
				velocity += right * delta
				sprite.scale.x = sprite_scale
				#print_debug("q")
			elif playerPostion.y - position.y < -distance_margin and !jump_detector_left.is_colliding():
				velocity += left * delta
				sprite.scale.x = -sprite_scale
				#print_debug("r")
			else:
				velocity.y = lerp(velocity.y , 0.0, 0.1)
		velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
		velocity.x = clamp(velocity.x, -max_fall_velocity, max_fall_velocity)
	#move opposite direction of player
	
	if is_on_floor() and jumpTimer.is_stopped() and isExhaustedTimer.is_stopped():
		if jump_detector_left.is_colliding() and jump_detector_left.get_collider() is TileMapLayer and player_is_to("right") and attacking.is_empty():
			var tile_data=jump_detector_left.get_collider().get_cell_tile_data(jump_detector_left.get_collider().get_coords_for_body_rid(jump_detector_left.get_collider_rid()))
			if tile_data.get_custom_data_by_layer_id(0)==1:
				jumping = true
				jumpTimer.start()
				jumpEndTimer.start()
				jump_direction = left
				sprite.scale.x = -sprite_scale
				#print_debug("s")
		if jump_detector_right.is_colliding() and jump_detector_right.get_collider() is TileMapLayer and player_is_to("left") and attacking.is_empty():
			var tile_data=jump_detector_right.get_collider().get_cell_tile_data(jump_detector_right.get_collider().get_coords_for_body_rid(jump_detector_right.get_collider_rid()))
			if tile_data.get_custom_data_by_layer_id(0)==1:
				jumping = true
				jumpTimer.start()
				jumpEndTimer.start()
				jump_direction = right
				sprite.scale.x = sprite_scale
				#print_debug("t")
	

	#switch gravity when close enough to wall (after jump)
	if wall_detector_left.is_colliding() and wall_detector_left.get_collider() is TileMapLayer and jumping:# and wall_detector_left.get_collider().get_class() != "CharacterBody2D":
		var tile_data=wall_detector_left.get_collider().get_cell_tile_data(wall_detector_left.get_collider().get_coords_for_body_rid(wall_detector_left.get_collider_rid()))
		if tile_data.get_custom_data_by_layer_id(1)==1:
			switch_gravity("left")
			jumping = false
			sprite.scale.x = -sprite_scale
			#print_debug("u")
	if wall_detector_right.is_colliding() and wall_detector_right.get_collider() is TileMapLayer and jumping:# and !wall_detector_right.get_collider().get_class() != "CharacterBody2D":
		var tile_data=wall_detector_right.get_collider().get_cell_tile_data(wall_detector_right.get_collider().get_coords_for_body_rid(wall_detector_right.get_collider_rid()))
		if tile_data.get_custom_data_by_layer_id(1)==1:
			switch_gravity("right")
			sprite.scale.x = sprite_scale
			jumping = false
			#print_debug("v")
		
	#adjust up direction for gravity to work normally
	up_direction = -gravity_dir
	#knockback MIGHT REMOVE
	#velocity += knockback
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
	get_tree().current_scene.get_node("Level").spawn_fire_left()
func spawn_fire_right():
	get_tree().current_scene.get_node("Level").spawn_fire_right()
func spawn_fire_bottom():
	get_tree().current_scene.get_node("Level").spawn_fire_bottom()

#attacks depending on position
func _on_attack_timer_timeout() -> void:
	#print_debug(spawning_spikes)
	if isExhaustedTimer.is_stopped() and !will_be_exhausted and is_on_floor():
		match state:
			"left":
				spawn_fire_right()
			"right":
				spawn_fire_left()
			"up":
				if randi() % 2 == 0:
					spawn_spikes()
					print_debug("start_spawn")
				else:	
					spawn_fire_bottom()
		if state != "down":
			attacking.append(0)
	attackTimer.start()
	
func spawn_spikes():
	spawning_spikes = true
	spikeEndTimer.start()
func not_attacking():
	attacking.pop_back()
func _on_exhaustion_timer_timeout() -> void:
	if !attacking.is_empty():
		will_be_exhausted = true
	else:
		switch_to_down()
		isExhaustedTimer.start()


func _on_spike_end_timer_timeout() -> void:
	spawning_spikes = false
	attacking.pop_back()
	print_debug("spike timeout")
	
	#for spike in spikeSpawner.get_children():
		#spikeSpawner.remove_child(spike)


func _on_jump_end_timer_timeout() -> void:
	jumping = false
	
func player_is_to(direction: String):
	match direction:
		"left":
			match state:
				"down":
					if playerPostion.x - position.x <= 0:
						return true 
				"up":
					if playerPostion.x - position.x >= 0:
						return true 
				"left":
					if playerPostion.y - position.y <= 0:
						return true 
				"right":
					if playerPostion.y - position.y >= 0:
						return true 
		"right":
			match state:
				"down":
					if playerPostion.x - position.x >= 0:
						return true 
				"up":
					if playerPostion.x - position.x <= 0:
						return true 
				"left":
					if playerPostion.y - position.y >= 0:
						return true 
				"right":
					if playerPostion.y - position.y <= 0:
						return true 
	return false

func _on_attack_buffer_timer_timeout() -> void:
	#print_debug("timedout")
	will_be_exhausted = false
	switch_to_down()
	isExhaustedTimer.start()
	
	
#damage + knockback if player jumps on 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and state == "down":
		body.take_damage(1, 10, position)


func _on_spike_timer_timeout() -> void:
	if spawning_spikes and !spikeEndTimer.is_stopped() and isExhaustedTimer.is_stopped() and is_on_floor():
		#print_debug(spawning_spikes)
		#print_debug("c")
		var instance = load("res://tscn_files/spike.tscn").instantiate()
		spikeSpawner.add_child(instance)
		instance.rotation = deg_to_rad(randf_range(-70, 70))
		spikeTimer.start()
