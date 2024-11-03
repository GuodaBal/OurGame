extends Node2D

var speed = 0.2

var fire_left = false
var fire_right = false
var fire_down = false

@onready var path_left := $PathLeft/PathFollow2D as PathFollow2D
@onready var path_right := $PathRight/PathFollow2D as PathFollow2D

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if fire_left:
		path_left.progress_ratio += speed * delta
		if(path_left.progress_ratio == 1):
			path_left.progress_ratio = 0
			fire_left=false
			path_left.remove_child(path_left.get_child(0))
	if fire_right:
		path_right.progress_ratio += speed * delta
		if(path_right.progress_ratio == 1):
			path_right.progress_ratio = 0
			fire_right=false
			path_right.remove_child(path_right.get_child(0))
			


func spawn_fire_left():
	var instance = load("res://tscn_files/fire.tscn").instantiate()
	path_left.add_child(instance)
	fire_left = true
	path_left.progress_ratio = 0
	
func spawn_fire_right():
	var instance = load("res://tscn_files/fire.tscn").instantiate()
	path_right.add_child(instance)
	instance.rotation=deg_to_rad(180)
	fire_right = true
	path_right.progress_ratio = 0
