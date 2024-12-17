extends Control

@onready var frames = [$Frame1, $Frame2, $Frame3, $Frame4]
var current_frame = 0

func _ready() -> void:
	frames[current_frame].visible = true
	current_frame+=1


func _input(event: InputEvent) -> void:
	if current_frame == 4:
		change_to_start()
		return
	if Input.is_action_just_pressed("ui_accept"):
		frames[current_frame].visible = true
		current_frame+=1

func change_to_start():
	get_tree().change_scene_to_file("res://tscn_files/main.tscn")
