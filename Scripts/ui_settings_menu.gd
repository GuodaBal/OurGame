extends Control


@onready var GraphicsMenu := $CanvasLayer/Graphics
@onready var SoundMenu := $CanvasLayer/Sound
@onready var ControlsMenu := $CanvasLayer/ControlsScroll

@onready var Fullscreen := $CanvasLayer/Graphics/FullscreenButton
@onready var ResolutionSelector := $CanvasLayer/Graphics/ResolutionSelector

@onready var LeftButton := $CanvasLayer/ControlsScroll/Controls/LeftButton
@onready var RightButton := $CanvasLayer/ControlsScroll/Controls/RightButton
@onready var JumpButton := $CanvasLayer/ControlsScroll/Controls/JumpButton
@onready var AttackButton := $CanvasLayer/ControlsScroll/Controls/AttackButton
@onready var Ability1Button := $CanvasLayer/ControlsScroll/Controls/Ability1Button
@onready var Ability2Button := $CanvasLayer/ControlsScroll/Controls/Ability2Button
@onready var Ability3Button := $CanvasLayer/ControlsScroll/Controls/Ability3Button
@onready var MenuOpenButton := $CanvasLayer/ControlsScroll/Controls/MenuButton

var Music_Bus_ID = AudioManager.get_MusicID()
var SFX_Bus_ID = AudioManager.get_SFXID()
var Master_Bus_ID = AudioManager.get_MasterID()
var mute_press = AudioManager.get_mute_state()  # atkurkite išsaugotą būseną
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
	#Makes the setting buttons display the chosen settings
	if DisplayServer.window_get_mode() == 3:
		Fullscreen.text = "On"
	else:
		Fullscreen.text = "Off"
	for index in ResolutionSelector.item_count:
		if ResolutionSelector.get_item_text(index) == str(Settings.resolution_x)+"x"+str(Settings.resolution_y):
			ResolutionSelector.select(index)
	LeftButton.text = InputMap.action_get_events("move_left")[0].as_text().replace("(Physical)", "")
	RightButton.text = InputMap.action_get_events("move_right")[0].as_text().replace("(Physical)", "")
	JumpButton.text = InputMap.action_get_events("jump")[0].as_text().replace("(Physical)", "")
	AttackButton.text = InputMap.action_get_events("attack")[0].as_text().replace("(Physical)", "")
	Ability1Button.text = InputMap.action_get_events("fire_ability")[0].as_text().replace("(Physical)", "")
	Ability2Button.text = InputMap.action_get_events("nature_ability")[0].as_text().replace("(Physical)", "")
	Ability3Button.text = InputMap.action_get_events("thunder_ability")[0].as_text().replace("(Physical)", "")
	MenuOpenButton.text = InputMap.action_get_events("menu")[0].as_text().replace("(Physical)", "")
	$CanvasLayer/Graphics/ZoomSlider.value = Settings.zoom
	$CanvasLayer/Sound/MusicSlider.value = Settings.music_volume
	$CanvasLayer/Sound/MiscSlider.value = Settings.misc_volume


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
	var save_file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	var save_data = {}
	save_data["settings"] = Settings.save_data()
	save_file.store_string(JSON.stringify(save_data))
	if get_parent().get_parent() == null:
		get_tree().change_scene_to_file("res://tscn_files/ui_main_menu.tscn")
	else:
		queue_free()


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Fullscreen.text = "Off"
		Settings.fullscreen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Fullscreen.text = "On"
		Settings.fullscreen = true
	var index = ResolutionSelector.get_selected_id()
	var resolution = ResolutionSelector.get_item_text(index).split("x")
	get_window().size = Vector2i(int(resolution[0]),int(resolution[1]))
	get_window().move_to_center()



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
		Settings.controls[action] = userPressedKey.as_text()
		


func _on_resolution_selector_item_selected(index: int) -> void:
	var resolution = ResolutionSelector.get_item_text(index).split("x")
	get_window().size = Vector2i(int(resolution[0]),int(resolution[1]))
	get_window().move_to_center()
	Settings.resolution_x = resolution[0]
	Settings.resolution_y = resolution[1]


func _on_music_slider_value_changed(value: float) -> void:
	AudioManager.set_music_volume(linear_to_db(value))
	AudioServer.set_bus_volume_db(Music_Bus_ID, linear_to_db(value))
	AudioServer.set_bus_mute(Music_Bus_ID, value < .05)
	Settings.music_volume = value


func _on_misc_slider_value_changed(value: float) -> void:
	AudioManager.set_SFX_volume(linear_to_db(value))
	AudioServer.set_bus_volume_db(SFX_Bus_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_Bus_ID, value < .05)
	Settings.misc_volume = value

func _on_music_slider_ready() -> void:
	$CanvasLayer/Sound/MusicSlider.value = db_to_linear( AudioManager.get_music_volume())

func _on_misc_slider_ready() -> void:
	$CanvasLayer/Sound/MiscSlider.value = db_to_linear( AudioManager.get_SFX_volume())

func _on_mute_button_ready() -> void:

	$CanvasLayer/Sound/MuteButton.button_pressed = mute_press
	AudioServer.set_bus_mute(Master_Bus_ID, mute_press)  # pritaikykite būseną garsui


func _on_mute_button_pressed() -> void:
	print('mute: ',mute_press)
	var mute_pressed = $CanvasLayer/Sound/MuteButton.button_pressed
	print('mute po: ',mute_press)
	
	AudioManager.set_mute_state(mute_pressed)  # išsaugokite naują būseną
	AudioServer.set_bus_mute(Master_Bus_ID, mute_pressed)  # pritaikykite naują būseną garsui
	Settings.mute = mute_pressed


func _on_zoom_slider_value_changed(value: float) -> void:
	for node in get_parent().get_children():
		if "Level" in node.name:
			node.get_node("MainCharacter").change_zoom(value)
	Settings.zoom = value
