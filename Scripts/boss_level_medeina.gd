extends Node2D


@onready var spikeIntervalTimer := $SpikeIntervalTimer as Timer #How often things spawn
@onready var rabbitIntervalTimer := $RabbitIntervalTimer as Timer
@onready var platformIntervalTimer := $PlatformIntervalTimer as Timer
@onready var sunBlocker := $TreeSunBlocker as AnimatableBody2D #Tree that blocks sun
@onready var animation := $AnimationPlayer as AnimationPlayer 
var coef = 1
var platforms= [[975, null], [925, null], [875, null]] as Array #Platforms spawn in one of 
#three heights. Stores platforms or null if line not busy


func start_spike_attack():
	spikeIntervalTimer.start()
func start_rabbit_attack():
	platformIntervalTimer.start()
	rabbitIntervalTimer.start(4)
func stop_attacks():
	spikeIntervalTimer.stop()
	platformIntervalTimer.stop()
	rabbitIntervalTimer.stop()
func block_sun():
	if !sunBlocker.visible:
		sunBlocker.grow()
		sunBlocker.visible = true
		animation.play("Fade_to_dark")
		sunBlocker.set_collision_layer_value(1, true)
func unblock_sun():
	sunBlocker.visible = false
	sunBlocker.set_collision_layer_value(1, false)
	animation.play("Remove_dark")
	

func _on_spike_interval_timer_timeout() -> void:
	var instance = load("res://tscn_files/ground_spike.tscn").instantiate()
	add_child(instance)
	move_child(instance, 2)
	#Some spawn under player, some in random spots
	if randi()%3 == 0:
		instance.position = Vector2(get_node("MainCharacter").position.x, 980)
	else:
		instance.position = Vector2(randf_range(500, 1700), 960)
	instance.spawn(coef)
	spikeIntervalTimer.start(randf_range(0.9, 1.6)/coef)


func _on_platform_interval_timer_timeout() -> void:
	platforms.shuffle()
	for platform in platforms:
		if platform[1] == null:
			platform[1] =  load("res://tscn_files/moving_platform.tscn").instantiate()
			add_child(platform[1])
			platform[1].position.y = platform[0]
			move_child(platform[1], 2)
			#Spawns randomly from left or right
			if randi()%2 == 0:
				platform[1].move("left", coef)
			else:
				platform[1].move("right", coef)
			break
	platformIntervalTimer.start(2.5)


func _on_rabbit_interval_timer_timeout() -> void:
	var instance =  load("res://tscn_files/rabbit_for_boss.tscn").instantiate()
	add_child(instance)
	instance.SPEED*=coef
	if randi()%2 == 0:
		instance.position = Vector2(150, 1050)
		instance.direction = 1
	else:
		instance.position = Vector2(1800, 1050)
		instance.direction = -1
	move_child(instance, 2)
	rabbitIntervalTimer.start(randf_range(0.6, 1.2)/coef)
	
#When stage changes
func change_environment(stage):
	get_node("Stage"+str(stage)+"BG").visible = true
