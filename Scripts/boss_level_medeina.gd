extends Node2D


@onready var spikeIntervalTimer := $SpikeIntervalTimer as Timer
@onready var sunBlocker := $TreeSunBlocker as AnimatableBody2D
@onready var animation := $AnimationPlayer as AnimationPlayer
var coef = 1
var platformHeights = [[950, 0], [880, 0], [800, 0]] #Platforms spawn in one of three heights
#0 Shows that height has no platform


func start_spike_attack():
	spikeIntervalTimer.start()
func stop_attacks():
	spikeIntervalTimer.stop()
	
func block_sun():
	sunBlocker.visible = true
	sunBlocker.grow()
	animation.play("Fade_to_dark")
	
func unblock_sun():
	sunBlocker.visible = false
	animation.play("Remove_dark")
	
func spawn_platform():
	for height in platformHeights:
		if height[1] == 0:
			height[1] = 1
			var instance = load("res://tscn_files/moving_platform.tscn").instantiate()
			add_child(instance)
			move_child(instance, 2)
			#Spawns randomly from left or right
			if randi()%2 == 0:
				instance.move("left")
			else:
				instance.move("right")
			instance.position = Vector2(0, height[0])
			break

func _on_spike_interval_timer_timeout() -> void:
	var instance = load("res://tscn_files/ground_spike.tscn").instantiate()
	add_child(instance)
	move_child(instance, 2)
	#Some spawn under player, some in random spots
	if randi()%3 == 0:
		instance.position = Vector2(get_node("MainCharacter").position.x, 980)
	else:
		instance.position = Vector2(randf_range(500, 1700), 980)
	instance.spawn(coef)
	spikeIntervalTimer.start(randf_range(0.6, 1.2))


func _on_platform_interval_timer_timeout() -> void:
	spawn_platform()
