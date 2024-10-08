extends Control


@onready var GraphicsMenu := $Graphics
@onready var SoundMenu := $Sound
@onready var ControlsMenu := $ControlsScroll

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GraphicsMenu.visible = true
	SoundMenu.visible = false
	ControlsMenu.visible = false
	var group = ButtonGroup.new()
	$Options/Graphics.button_group = group
	$Options/Sound.button_group = group
	$Options/Controls.button_group = group
	if DisplayServer.window_get_mode() == 3:
		$Graphics/FullscreenButton.text = "On"
	else:
		$Graphics/FullscreenButton.text = "Off"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_graphics_pressed() -> void:
	GraphicsMenu.visible = true
	SoundMenu.visible = false
	ControlsMenu.visible = false


func _on_sound_pressed() -> void:
	GraphicsMenu.visible = false
	SoundMenu.visible = true
	ControlsMenu.visible = false


func _on_controls_pressed() -> void:
	GraphicsMenu.visible = false
	SoundMenu.visible = false
	ControlsMenu.visible = true

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://tscn_files/ui_main_menu.tscn")


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		$Graphics/FullscreenButton.text = "Off"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$Graphics/FullscreenButton.text = "On"
