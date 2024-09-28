extends CanvasLayer



func _on_quit_pressed():
	get_tree().quit()


func _on_try_again_pressed():
	get_tree().change_scene_to_file("res://tscn_files/main.tscn")
