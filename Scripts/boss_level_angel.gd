extends Node2D

@onready var enemySpawnLocation1 = $EnemySpawn1.position as Vector2
@onready var enemySpawnLocation2 = $EnemySpawn2.position as Vector2
@onready var enemySpawnLocation3 = $EnemySpawn3.position as Vector2
@onready var enemySpawnLocation4 = $EnemySpawn4.position as Vector2
@onready var camera = $MainCharacter/Camera2D
var spawnLocations

@onready var cracks_material := $Sprite2D8.material as ShaderMaterial

@onready var murals := [
	$Sprite2D7,$Sprite2D6,$Sprite2D5,$Sprite2D4,$Sprite2D2,$Sprite2D
]
var shake_strengths = [1.0, 3.0, 8.0]    # atitinkamai stiprėjantis camera shake
var enemies_killed = 0
var cracks_thresholds = [0.3, 0.5, 0.7]  # 3 etapai
var current_stage = 0
const STAGE_KILL_REQUIREMENTS := [2, 4, 6]  # Po kiek priešų reikia kiekvienam etapui

func _ready() -> void:
	AudioManager.stop_forestfire_sound()
	AudioManager.stop_forest_sound()
	AudioManager.stop_water_sound()
	spawnLocations = [enemySpawnLocation1, enemySpawnLocation2, enemySpawnLocation3, enemySpawnLocation4]
	
	 # Pradžioje – niekas nesimato
	for mural in murals:
		var mat := mural.material as ShaderMaterial
		mat.set_shader_parameter("reveal_amount", 0.0)

func spawn_random_enemy():
	print_debug("spawning")
	var spawnPoint = randi_range(1, 4)
	var enemy
	var spawnPos = spawnLocations[spawnPoint-1]
	#If player is too close to selected floor spawnpoint, pick different one to prevent spawning on player
	if spawnPoint <= 2 and abs(spawnPos - get_node("MainCharacter").position).length() < 150:
		spawn_random_enemy()
		return
	#FloorEnemies
	if spawnPoint <= 2:
		match randi_range(1, 4):
			1:
				enemy =  load("res://tscn_files/Enemies/enemy.tscn").instantiate()
			2:
				enemy =  load("res://tscn_files/Enemies/wendigo.tscn").instantiate()
			3:
				enemy =  load("res://tscn_files/Enemies/spider.tscn").instantiate()
			4:
				enemy = load("res://tscn_files/Enemies/rabbit.tscn").instantiate()
	#FlyingEnemies
	else:
		match randi_range(1, 2):
			1:
				enemy =  load("res://tscn_files/Enemies/bat_enemy.tscn").instantiate()
			2:
				enemy =  load("res://tscn_files/Enemies/wasp.tscn").instantiate()
	#enemy.hp *= 1.3
	add_child(enemy)
	enemy.position = spawnLocations[spawnPoint-1]
	enemy.range = 40000
	enemy.hp_chance = 4
	move_child(enemy, 3)
	
	var angel:= get_node_or_null("Angel")
	var beam := get_node_or_null("AngelBeam")
	if angel and beam:
		beam.play_beam(angel.global_position, spawnPos)


func _on_child_exiting_tree(node: Node) -> void:
	if node.is_in_group("Enemy") and get_node("Angel") != null:
		$Angel.take_damage(1)
		enemies_killed += 1
		if enemies_killed % 2 == 0 and current_stage < 3:
			camera.shake(8.0)
			increase_cracks_and_shake(current_stage)
			reveal_murals_stage(current_stage)
			current_stage += 1	

func reveal_murals_stage(stage: int):
	var start_index = stage * 2
	for i in range(start_index, start_index + 2):
		var mural = murals[i]
		var mat = mural.material as ShaderMaterial
		var tween = create_tween()
		tween.tween_property(mat, "shader_parameter/reveal_amount", 1.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func increase_cracks_and_shake(stage: int):
	# 1) Padidiname plyšių threshold
	var new_threshold = cracks_thresholds[stage]
	cracks_material.set_shader_parameter("threshold", new_threshold)

	# 2) Iškviečiame camera.shake su atitinkama stiprybe
	var shake_amount = shake_strengths[stage]
	camera.shake(shake_amount)
				

func over():
	await get_tree().create_timer(1).timeout
	get_parent().get_node("AnimationPlayer").play("Fade_out_long")
	await get_parent().get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://tscn_files/ui_end_credits.tscn")
