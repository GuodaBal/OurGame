extends Control

@onready var click = $AudioStreamPlayer
func _ready() -> void:
	for child in get_parent().get_children():
		if "Level" in child.name:
			child.get_tree().paused = true


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		if get_parent().get_node_or_null("Menu") == null:
			for child in get_parent().get_children():
				if "Level" in child.name:
					child.get_tree().paused = false
			get_parent().is_popup_on = false
			accept_event()
			queue_free()
		


func _on_continue_pressed() -> void:
	for child in get_parent().get_children():
			if "Level" in child.name:
				child.get_tree().paused = false
	get_parent().is_popup_on = false
	queue_free()
	
func _on_settings_pressed() -> void:
	var settings_menu = load("res://tscn_files/ui_settings_menu.tscn").instantiate()
	add_sibling(settings_menu)
	print_debug(get_parent().is_popup_on)
	for child in get_parent().get_children():
			if "Level" in child.name:
				child.get_tree().paused = true

func _on_main_menu_pressed() -> void:
	AudioPlayer.play()
	for child in get_parent().get_children():
		if "Level" in child.name:
			child.get_tree().paused = false
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
