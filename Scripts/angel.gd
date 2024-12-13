extends AnimatedSprite2D

@onready var spawnTimer := $SpawnTimer as Timer

var rangeStart = 3
var rangeEnd = 6

var health = 40
var spawnSpeedCoef = 1.0
var timePassed = 0.0
	


func _on_spawn_timer_timeout() -> void:
	get_parent().spawn_random_enemy()
	spawnTimer.start(randf_range(rangeStart * spawnSpeedCoef, rangeEnd * spawnSpeedCoef))
	print_debug("spawn")

func take_damage(amount):
	health-=amount
	print_debug(health)
	if health <= 0:
		queue_free()


func _on_speed_coef_timeout() -> void:
	timePassed += 1
	spawnSpeedCoef = 1.0 - (timePassed/150)
	spawnSpeedCoef = clamp(spawnSpeedCoef, 0.6, 1.0)
	print_debug(spawnSpeedCoef)
