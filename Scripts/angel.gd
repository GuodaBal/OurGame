extends AnimatedSprite2D

@onready var spawnTimer := $SpawnTimer as Timer

var rangeStart = 3
var rangeEnd = 6

var health = 2
var spawnSpeedCoef = 1.0
var timePassed = 0.0

signal over

func _process(delta: float) -> void:
	over.connect(get_parent().over)
	if !is_playing():
		play("idle")

func _on_spawn_timer_timeout() -> void:
	play("spawning")
	await animation_finished
	get_parent().spawn_random_enemy()
	spawnTimer.start(randf_range(rangeStart * spawnSpeedCoef, rangeEnd * spawnSpeedCoef))

func take_damage(amount):
	health-=amount
	print_debug(health)
	if health <= 0:
		spawnTimer.stop()
		print_debug("dying")
		for node in get_parent().get_children():
			print_debug(node)
			if node.is_in_group("Enemy"):
				print_debug(node)
				node.die()
		play("death")
		await animation_finished
		over.emit()
		queue_free()


func _on_speed_coef_timeout() -> void:
	timePassed += 1
	spawnSpeedCoef = 1.0 - (timePassed/150)
	spawnSpeedCoef = clamp(spawnSpeedCoef, 0.6, 1.0)
