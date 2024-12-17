extends Control

func _ready() -> void:
	AudioManager.play_mainmenu()
	$AnimationPlayer.play("scroll")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://tscn_files/ui_main_menu.tscn")
