extends Node2D


@onready var spikeIntervalTimer := $SpikeIntervalTimer as Timer #How often things spawn
@onready var rabbitIntervalTimer := $RabbitIntervalTimer as Timer
@onready var platformIntervalTimer := $PlatformIntervalTimer as Timer
@onready var sunBlocker := $TreeSunBlocker as AnimatableBody2D #Tree that blocks sun
@onready var animation := $AnimationPlayer as AnimationPlayer 
@onready var before := $Before as TileMapLayer
@onready var after := $After as TileMapLayer
@onready var MedeinaBe = $MedeinaBe
@onready var MedeinaAF = $MedeinaAF
var coef = 1
var platforms= [[975, null], [925, null], [875, null]] as Array #Platforms spawn in one of 
#three heights. Stores platforms or null if line not busy

var lastSpikeAtPlayer = false #If last spike was spawned under player, don't spawn it under
#player again to prevent getting trapped


func _ready() -> void:
	AudioManager.stop_forest_sound() 
	animation.play("Remove_dark")
	if GlobalVariables.MedeinaDone:		
		before.visible = false
		before.collision_enabled = false
		end_level()
		$Medeina.queue_free()
		MedeinaAF.play()
	else:
		after.visible = false
		after.collision_enabled = false
		MedeinaBe.play()

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
	sunBlocker.can_burn = false
	animation.play("Remove_dark")
func is_sun_blocked():
	return sunBlocker.can_burn
	
	

func _on_spike_interval_timer_timeout() -> void:
	var instance = load("res://tscn_files/ground_spike.tscn").instantiate()
	add_child(instance)
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
		instance.set_direction(1)
	else:
		instance.position = Vector2(1800, 1050)
		instance.set_direction(-1) 
	rabbitIntervalTimer.start(randf_range(0.6, 1.2)/coef)
	
#When stage changes
func change_environment(stage):
	await animation.animation_finished
	get_node("Stage"+str(stage)+"BG").visible = true
	
func end_level():
	before.visible = false
	before.collision_enabled = false
	after.visible = true
	after.collision_enabled = true
	for i in range(1,4):
		get_node("Stage"+str(i)+"BG").visible = false
	await get_tree().process_frame
	
