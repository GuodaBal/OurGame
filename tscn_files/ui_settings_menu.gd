extends Control


@onready var GraphicsMenu := $Graphics
@onready var SoundMenu := $Sound
@onready var ControlsMenu := $ControlsScroll

@onready var LeftButton := $ControlsScroll/Controls/LeftButton
@onready var RightButton := $ControlsScroll/Controls/RightButton
@onready var JumpButton := $ControlsScroll/Controls/JumpButton
@onready var AttackButton := $ControlsScroll/Controls/AttackButton
@onready var Ability1Button := $ControlsScroll/Controls/Ability1Button
@onready var Ability2Button := $ControlsScroll/Controls/Ability2Button
@onready var Ability3Button := $ControlsScroll/Controls/Ability3Button
@onready var MenuOpenButton := $ControlsScroll/Controls/MenuButton

var waiting_for_input: bool = false
var button
var action


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
	LeftButton.text = InputMap.action_get_events("move_left")[0].as_text()
	RightButton.text = InputMap.action_get_events("move_right")[0].as_text()
	JumpButton.text = InputMap.action_get_events("jump")[0].as_text()
	AttackButton.text = InputMap.action_get_events("attack")[0].as_text()
	Ability1Button.text = InputMap.action_get_events("fire_ability")[0].as_text()
	Ability2Button.text = InputMap.action_get_events("nature_ability")[0].as_text()
	Ability3Button.text = InputMap.action_get_events("thunder_ability")[0].as_text()
	MenuOpenButton.text = InputMap.action_get_events("menu")[0].as_text()


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


func _on_left_button_pressed() -> void:
	waiting_for_input = true
	action = "move_left"
	button = LeftButton

func _on_right_button_pressed() -> void:
	waiting_for_input = true
	action = "move_right"
	button = RightButton


func _on_jump_button_pressed() -> void:
	waiting_for_input = true
	action = "jump"
	button = JumpButton


func _on_attack_button_pressed() -> void:
	waiting_for_input = true
	action = "attack"
	button = AttackButton


func _on_ability_1_button_pressed() -> void:
	waiting_for_input = true
	action = "fire_ability"
	button = Ability1Button


func _on_ability_2_button_pressed() -> void:
	waiting_for_input = true
	action = "nature_ability"
	button = Ability2Button


func _on_ability_3_button_pressed() -> void:
	waiting_for_input = true
	action = "thunder_ability"
	button = Ability3Button


func _on_menu_button_pressed() -> void:
	waiting_for_input = true
	action = "menu"
	button = MenuOpenButton

func _input(event: InputEvent) -> void:
	if (waiting_for_input and event is InputEventKey and event.pressed) or (waiting_for_input and event is InputEventMouseButton and event.pressed):
		var userPressedKey = event
		InputMap.action_erase_event(action, InputMap.action_get_events(action)[0])
		InputMap.action_add_event(action, userPressedKey)
		waiting_for_input = false
		button.text = userPressedKey.as_text()
		
