extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_node("Level").get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	get_parent().get_node("Level").get_tree().paused = false
	#get_tree().paused = false
	queue_free()


func _on_settings_pressed() -> void:
	var settings_menu = load("res://tscn_files/ui_settings_menu.tscn").instantiate()
	#get_parent().add_child(settings_menu)
	add_sibling(settings_menu)
	get_parent().print_tree()
	get_parent().get_node("Level").get_tree().paused = true
	#get_tree().change_scene_to_file("res://tscn_files/ui_settings_menu.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://tscn_files/ui_main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
