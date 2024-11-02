extends Node2D

var speed = 0.1

var fire_left = false
var fire_right = false
var fire_down = false

@onready var path_left := $PathLeft/PathFollow2D as PathFollow2D

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if fire_left:
		path_left.progress_ratio += speed * delta
		if(path_left.progress_ratio == 1):
			path_left.progress_ratio = 0
			fire_left=false
			path_left.remove_child(path_left.get_child(0))
			get_tree().current_scene.print_tree()
			


func spawn_fire_left():
	print_debug("spawned")
	var instance = load("res://tscn_files/fire.tscn").instantiate()
	path_left.add_child(instance)
	fire_left = true
	path_left.progress_ratio = 0
