extends Node2D


@onready var spikeIntervalTimer := $SpikeIntervalTimer as Timer #How often things spawn
@onready var rabbitIntervalTimer := $RabbitIntervalTimer as Timer
@onready var platformIntervalTimer := $PlatformIntervalTimer as Timer
@onready var sunBlocker := $TreeSunBlocker as AnimatableBody2D #Tree that blocks sun
@onready var animation := $AnimationPlayer as AnimationPlayer 
var coef = 1
var platforms= [[975, null], [925, null], [875, null]] as Array #Platforms spawn in one of 
#three heights. Stores platforms or null if line not busy

var lastSpikeAtPlayer = false #If last spike was spawned under player, don't spawn it under
#player again to prevent getting trapped


func _ready() -> void:
	animation.play("Remove_dark")
	if GlobalVariables.MedeinaDone:
		end_level()
		$Medeina.queue_free()

func start_spike_attack():
	spikeIntervalTimer.start()
func start_rabbit_attack():
	platformIntervalTimer.start()
	rabbitIntervalTimer.start(4)
func stop_attacks():
	spikeIntervalTimer.stop()
	platformIntervalTimer.stop()
	rabbitIntervalTimer.stop()
	platforms[0][0] = 975
	platforms[1][0] = 925
	platforms[2][0] = 875
func block_sun():
	sunBlocker.grow()
	sunBlocker.can_burn = true
	animation.play("Fade_to_dark")
	sunBlocker.set_collision_layer_value(1, true)
func unblock_sun():
	sunBlocker.set_collision_layer_value(1, false)
	animation.play("Remove_dark")
	
	

func _on_spike_interval_timer_timeout() -> void:
	var instance = load("res://tscn_files/ground_spike.tscn").instantiate()
	add_child(instance)
	move_child(instance, -5)
	#Some spawn under player, some in random spots
	if randi()%3 == 0 and !lastSpikeAtPlayer:
		instance.position = Vector2(get_node("MainCharacter").position.x + randi_range(-50, 50), 1115)
		lastSpikeAtPlayer = true
	else:
		instance.position = Vector2(randf_range(500, 1600), 1115)
		lastSpikeAtPlayer = false
	instance.spawn(coef)
	spikeIntervalTimer.start(randf_range(0.9, 1.6)/coef)


func _on_platform_interval_timer_timeout() -> void:
	for platform in platforms:
		if platform[1] == null:
			platform[1] =  load("res://tscn_files/moving_platform.tscn").instantiate()
			add_child(platform[1])
			platform[1].position.y = platform[0]
			move_child(platform[1], -5)
			#Spawns randomly from left or right
			if randi()%2 == 0:
				platform[1].move("left", coef)
			else:
				platform[1].move("right", coef)
			break
	platformIntervalTimer.start(2)
	platforms.shuffle()


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
	print_debug("should change")
	await animation.animation_finished
	get_node("Stage"+str(stage)+"BG").visible = true
	
func end_level():
	stop_attacks()
	$Before.visible = false
	$After.visible = true
	for i in range(1,4):
		get_node("Stage"+str(i)+"BG").visible = false
