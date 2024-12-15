extends Node

var fullscreen = true
var resolution_x = 1920
var resolution_y = 1080
var zoom = 1
var music_volume = 1
var misc_volume = 1
var mute = false
var controls = {
	"move_left" : "A",
	"move_right" : "D",
	"jump" : "SPACE",
	"attack" : "Left Mouse Button",
	"fire_ability" : "Right Mouse Button",
	"nature_ability" : "Q",
	"thunder_ability" : "E",
	"save" : "S",
	"continue_dialogue" : "ENTER",
	"skip_dialogue" : "SPACE"
}

#Godot can't convert from string to input code
var _MouseButton = {
	"None Mouse Button" : MOUSE_BUTTON_NONE,
	"Left Mouse Button" : MOUSE_BUTTON_LEFT,
	"Right Mouse Button" : MOUSE_BUTTON_RIGHT,
	"Middle Mouse Button" : MOUSE_BUTTON_MIDDLE,
	"Mouse Wheel Up" : MOUSE_BUTTON_WHEEL_UP,
	"Mouse Wheel Down" : MOUSE_BUTTON_WHEEL_DOWN,
	"Mouse Wheel Left" : MOUSE_BUTTON_WHEEL_LEFT,
	"Mouse Wheel Right" : MOUSE_BUTTON_WHEEL_RIGHT
}

func reset():
	fullscreen = true
	resolution_x = 1920
	resolution_y = 1080
	zoom = 1
	music_volume = 1
	misc_volume = 1
	mute = false
	controls = {
		"move_left" : "A",
		"move_right" : "D",
		"jump" : "SPACE",
		"attack" : "Left Mouse Button",
		"fire_ability" : "Right Mouse Button",
		"nature_ability" : "Q",
		"thunder_ability" : "E",
		"save" : "S",
		"continue_dialogue" : "ENTER",
		"skip_dialogue" : "SPACE"
	}
	
func save_data():
	var save_dict = {
		"fullscreen" : fullscreen,
		"resolution_x" : resolution_x,
		"resolution_y" : resolution_y,
		"zoom" : zoom,
		"music_volume" : music_volume,
		"misc_volume" : misc_volume,
		"mute" : mute
	}
	save_dict.merge(controls)
	return save_dict
	
func load_data():
	var save_file = FileAccess.open("user://settings.save", FileAccess.READ)
	var json_string = save_file.get_as_text()
	save_file.close()
	var json = JSON.parse_string(json_string)
	var data = json["settings"]
	for i in data.keys():
		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
			continue
		set(i, data[i])
	for key in controls.keys():
		if key in data:
			controls[key] = data[key]
			InputMap.action_erase_event(key, InputMap.action_get_events(key)[0])
			var event
			var keycode = find_presscode_from_string(data[key])
			if keycode <= 8:
				event = InputEventMouseButton.new()
				event.button_index = keycode
			else:
				event = InputEventKey.new()
				event.keycode = keycode
			InputMap.action_add_event(key, event)
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_window().size = Vector2i(int(resolution_x), int(resolution_y))
	get_window().move_to_center()
	
	AudioManager.set_music_volume(linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioManager.get_MusicID(), linear_to_db(music_volume))
	AudioServer.set_bus_mute(AudioManager.get_MusicID(), music_volume < .05)
	
	AudioManager.set_SFX_volume(linear_to_db(misc_volume))
	AudioServer.set_bus_volume_db(AudioManager.get_SFXID(), linear_to_db(misc_volume))
	AudioServer.set_bus_mute(AudioManager.get_SFXID(), misc_volume < .05)
	
	AudioManager.set_mute_state(mute)
	AudioServer.set_bus_mute(AudioManager.get_MasterID(), mute)

## Takes a string that describes a mouse button press and returns the appropriate code (an integer;
## please see the `MouseButton` enum). The function `OS.find_keycode_from_string` takes a string that
## describes a keypress and returns the appropriate keycode. But, this function pertains only to
## keyboard keys; there is no mouse equivalent. This is the mouse equivalent.
func find_mousecode_from_string(string: String) -> int:
	if string in _MouseButton:
		return _MouseButton[string]
	else:
		return _MouseButton["None Mouse Button"]

## Identical to `OS.find_keycode_from_string`, but accounts aswell for mouse presses. We can
## conflate these presses because values of the `MouseButton` enum. and values of the `Key` enum. only
## intersect for 0
func find_presscode_from_string(string: String) -> int:
	if OS.find_keycode_from_string(string) == 0:
		return find_mousecode_from_string(string)
	else:
		return OS.find_keycode_from_string(string)
