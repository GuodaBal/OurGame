extends Control

@onready var click = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for child in get_parent().get_children():
		if "Level" in child.name:
			child.get_tree().paused = true
	#get_parent().get_node("Level").get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		
		for child in get_parent().get_children():
			if "Level" in child.name:
				child.get_tree().paused = false
		#get_parent().get_node("Level").get_tree().paused = false
		queue_free()


func _on_continue_pressed() -> void:
	for child in get_parent().get_children():
			if "Level" in child.name:
				child.get_tree().paused = false
	queue_free()


func _on_settings_pressed() -> void:
	var settings_menu = load("res://tscn_files/ui_settings_menu.tscn").instantiate()
	#get_parent().add_child(settings_menu)
	add_sibling(settings_menu)
	get_parent().print_tree()
	get_parent().get_node("Level").get_tree().paused = true
	#get_tree().change_scene_to_file("res://tscn_files/ui_settings_menu.tscn")


func _on_main_menu_pressed() -> void:
	AudioPlayer.play()
	get_parent().get_node("Level").get_tree().paused = false
	get_tree().change_scene_to_file("res://tscn_files/ui_main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
	


func _on_continue_mouse_entered() -> void:
	click.play()


func _on_settings_mouse_entered() -> void:
	click.play()


func _on_main_menu_mouse_entered() -> void:
	click.play()

func _on_exit_mouse_entered() -> void:
	click.play()
