extends Node2D

@onready var enemySpawnLocation1 = $EnemySpawn1.position as Vector2
@onready var enemySpawnLocation2 = $EnemySpawn2.position as Vector2
@onready var enemySpawnLocation3 = $EnemySpawn3.position as Vector2
@onready var enemySpawnLocation4 = $EnemySpawn4.position as Vector2

var spawnLocations

func _ready() -> void:
	spawnLocations = [enemySpawnLocation1, enemySpawnLocation2, enemySpawnLocation3, enemySpawnLocation4]

func spawn_random_enemy():
	print_debug("spawning")
	var spawnPoint = randi_range(1, 4)
	var enemy
	#If player is too close to selected floor spawnpoint, pick different one to prevent spawning on player
	if spawnPoint <= 2 and abs(spawnLocations[spawnPoint-1] - get_node("MainCharacter").position).length() < 150:
		spawn_random_enemy()
		return
	#FloorEnemies
	if spawnPoint <= 2:
		match randi_range(1, 4):
			1:
				enemy =  load("res://tscn_files/enemy.tscn").instantiate()
			2:
				enemy =  load("res://tscn_files/wendigo.tscn").instantiate()
			3:
				enemy =  load("res://tscn_files/spider.tscn").instantiate()
			4:
				enemy = load("res://tscn_files/rabbit.tscn").instantiate()
	#FlyingEnemies
	else:
		match randi_range(1, 2):
			1:
				enemy =  load("res://tscn_files/bat_enemy.tscn").instantiate()
			2:
				enemy =  load("res://tscn_files/wasp.tscn").instantiate()
	#enemy.hp *= 1.3
	add_child(enemy)
	enemy.position = spawnLocations[spawnPoint-1]
	enemy.range = 40000
	move_child(enemy, 3)


func _on_child_exiting_tree(node: Node) -> void:
	if node.is_in_group("Enemy") and get_node("Angel") != null:
		$Angel.take_damage(1)

func over():
	get_parent().get_node("AnimationPlayer").play("fade_out")
	await get_parent().get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://tscn_files/ui_end_credits.tscn")
