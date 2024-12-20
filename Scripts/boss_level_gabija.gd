extends Node2D

var sideSpeed = 0.2
var bottomSpeed = 550

@onready var path_left := $PathLeft/PathFollow2D as PathFollow2D
@onready var path_right := $PathRight/PathFollow2D as PathFollow2D

@onready var bottomLeftSpawn := $BottomFireLeft as Node2D
@onready var bottomRightSpawn := $BottomFireRight as Node2D 

@onready var levelBe = $TileMapLayer as TileMapLayer
@onready var levelAf = $TileMapLayer2 as TileMapLayer

@onready var GabijaBe = $GabijaBe
@onready var GabijaAF = $GabijaAf

@onready var audio = $Fire
var fire_left = false
var fire_right = false
var fire_down = false

var peak = -600
var valley = 100
var has_peaked = false
var bottom_phase = "one"
var distance = 300

var bottom_fire_left
var bottom_fire_right

func _ready() -> void:
	AudioManager.stop_forestfire_sound()
	if GlobalVariables.GabijaDone:
		levelBe.visible = false
		levelBe.collision_enabled = false
		get_node("Gabija").queue_free()
	else:
		levelAf.visible = false
		levelAf.visible = false
		await get_parent().get_node("AnimationPlayer").animation_finished
		DialogueManager.show_dialogue_balloon(load("res://Dialogue/gabija.dialogue"), "meet")
		await DialogueManager.dialogue_ended
		$Gabija.can_start()
		
		

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if fire_left:
		path_left.progress_ratio += sideSpeed * delta
		if(path_left.progress_ratio == 1):
			path_left.progress_ratio = 0
			fire_left=false
			path_left.remove_child(path_left.get_child(0))
			$Gabija.not_attacking()
	if fire_right:
		path_right.progress_ratio += sideSpeed * delta
		if(path_right.progress_ratio == 1):
			path_right.progress_ratio = 0
			fire_right=false
			path_right.remove_child(path_right.get_child(0))
			$Gabija.not_attacking()
	if fire_down:
		if bottom_fire_left.position.y > peak and !has_peaked:
			bottom_fire_left.position.y-=delta*bottomSpeed
			bottom_fire_right.position.y-=delta*bottomSpeed
		elif !has_peaked and bottom_fire_left.position.y <= peak:
			has_peaked = true
		elif has_peaked and bottom_fire_left.position.y < valley:
			bottom_fire_left.position.y+=delta*bottomSpeed
			bottom_fire_right.position.y+=delta*bottomSpeed
		elif has_peaked and bottom_fire_left.position.y >= valley:
			has_peaked=false
			if bottom_phase == "done":
				bottomLeftSpawn.remove_child(bottomLeftSpawn.get_child(0))
				bottomRightSpawn.remove_child(bottomRightSpawn.get_child(0))
				fire_down = false
				$Gabija.not_attacking()
			else:
				spawn_fire_bottom()


func spawn_fire_left():
	var instance = load("res://tscn_files/fire.tscn").instantiate()
	path_left.progress_ratio = 0
	path_left.add_child(instance)
	fire_left = true
	
func spawn_fire_right():
	var instance = load("res://tscn_files/fire.tscn").instantiate()
	instance.rotation=deg_to_rad(180)
	path_right.progress_ratio = 0
	path_right.add_child(instance)
	fire_right = true

func spawn_fire_bottom():
	fire_down=true
	match bottom_phase:
		"one":
			bottom_fire_left = load("res://tscn_files/fire.tscn").instantiate()
			bottomLeftSpawn.add_child(bottom_fire_left)
			bottom_fire_right = load("res://tscn_files/fire.tscn").instantiate()
			bottomRightSpawn.add_child(bottom_fire_right)
			bottom_phase = "two"
		"two":
			bottom_fire_left.position.x+=distance
			bottom_fire_right.position.x-=distance
			bottom_phase = "three"
		"three":
			bottom_fire_left.position.x+=distance
			bottom_fire_right.position.x-=distance
			bottom_phase = "done"
		"done":
			bottom_phase="one"
			spawn_fire_bottom()
	
#Activated when Gabija dies
func switch_scene():
	levelBe.visible = false
	levelBe.collision_enabled = false
	levelAf.visible = true
	levelAf.visible = true
	GabijaBe.stop()
	GabijaAF.play()

func _on_ready() -> void:
	if(GlobalVariables.GabijaDone):
		GabijaAF.play()
	else:
		GabijaBe.play()
