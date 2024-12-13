extends Node2D

@onready var enemySpawnLocation1 = $EnemySpawn1.position as Vector2
@onready var enemySpawnLocation2 = $EnemySpawn2.position as Vector2
@onready var enemySpawnLocation3 = $EnemySpawn3.position as Vector2
@onready var enemySpawnLocation4 = $EnemySpawn4.position as Vector2

var spawnLocations

func _ready() -> void:
	spawnLocations = [enemySpawnLocation1, enemySpawnLocation2, enemySpawnLocation3, enemySpawnLocation4]

func spawn_random_enemy():
	var spawnPoint = randi_range(1, 4)
	var enemy
	#FloorEnemies
	if spawnPoint <= 2:
		match randi_range(1, 3):
			1:
				enemy =  load("res://tscn_files/enemy.tscn").instantiate()
			2:
				enemy =  load("res://tscn_files/wendigo.tscn").instantiate()
			3:
				enemy =  load("res://tscn_files/spider.tscn").instantiate()
			4:
				#Eventually rabbit
				enemy = load("res://tscn_files/rabbit.gd").instantiate()
	#FlyingEnemies
	else:
		match randi_range(1, 1):
			1:
				enemy =  load("res://tscn_files/bat_enemy.tscn").instantiate()
			2:
				#Eventually wasp
				enemy =  load("res://tscn_files/.tscn").instantiate()
	enemy.hp *= 1.3
	add_child(enemy)
	enemy.position = spawnLocations[spawnPoint-1]
	move_child(enemy, 1)


func _on_child_exiting_tree(node: Node) -> void:
	if node.is_in_group("Enemy"):
		$Angel.take_damage(1)
