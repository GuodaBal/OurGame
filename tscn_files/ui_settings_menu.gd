extends Control


@onready var GraphicsMenu := $CanvasLayer/Graphics
@onready var SoundMenu := $CanvasLayer/Sound
@onready var ControlsMenu := $CanvasLayer/ControlsScroll

@onready var LeftButton := $CanvasLayer/ControlsScroll/Controls/LeftButton
@onready var RightButton := $CanvasLayer/ControlsScroll/Controls/RightButton
@onready var JumpButton := $CanvasLayer/ControlsScroll/Controls/JumpButton
@onready var AttackButton := $CanvasLayer/ControlsScroll/Controls/AttackButton
@onready var Ability1Button := $CanvasLayer/ControlsScroll/Controls/Ability1Button
@onready var Ability2Button := $CanvasLayer/ControlsScroll/Controls/Ability2Button
@onready var Ability3Button := $CanvasLayer/ControlsScroll/Controls/Ability3Button
@onready var MenuOpenButton := $CanvasLayer/ControlsScroll/Controls/MenuButton

var waiting_for_input: bool = false
var button
var action


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GraphicsMenu.visible = true
	SoundMenu.visible = false
	ControlsMenu.visible = false
	var group = ButtonGroup.new()
	$CanvasLayer/Options/Graphics.button_group = group
	$CanvasLayer/Options/Sound.button_group = group
	$CanvasLayer/Options/Controls.button_group = group
	if DisplayServer.window_get_mode() == 3:
		$CanvasLayer/Graphics/FullscreenButton.text = "On"
	else:
		$CanvasLayer/Graphics/FullscreenButton.text = "Off"
	LeftButton.text = InputMap.action_get_events("move_left")[0].as_text().replace("(Physical)", "")
	RightButton.text = InputMap.action_get_events("move_right")[0].as_text().replace("(Physical)", "")
	JumpButton.text = InputMap.action_get_events("jump")[0].as_text().replace("(Physical)", "")
	AttackButton.text = InputMap.action_get_events("attack")[0].as_text().replace("(Physical)", "")
	Ability1Button.text = InputMap.action_get_events("fire_ability")[0].as_text().replace("(Physical)", "")
	Ability2Button.text = InputMap.action_get_events("nature_ability")[0].as_text().replace("(Physical)", "")
	Ability3Button.text = InputMap.action_get_events("thunder_ability")[0].as_text().replace("(Physical)", "")
	MenuOpenButton.text = InputMap.action_get_events("menu")[0].as_text().replace("(Physical)", "")


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
	if get_parent().get_parent() == null:
		get_tree().change_scene_to_file("res://tscn_files/ui_main_menu.tscn")
	else:
		queue_free()


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$CanvasLayer/Graphics/FullscreenButton.text = "Off"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$CanvasLayer/Graphics/FullscreenButton.text = "On"


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
		


func _on_resolution_selector_item_selected(index: int) -> void:
	var resolution = $CanvasLayer/Graphics/ResolutionSelector.get_item_text(index).split("x")
	print_debug(get_tree().root.get_content_scale_size()[0])
	print_debug(get_tree().root.get_content_scale_size()[1])
	#get_tree().root.content_scale_size = Vector2i(int(resolution[0]),int(resolution[1]))
	#DisplayServer.window_set_size(Vector2i(int(resolution[0]),int(resolution[1])))
	#get_viewport().size = Vector2i(int(resolution[0]),int(resolution[1]))
	get_window().size = Vector2i(int(resolution[0]),int(resolution[1]))
	get_window().move_to_center()

	#Viewport.widt
