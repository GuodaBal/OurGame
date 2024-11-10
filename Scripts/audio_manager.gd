extends Node

@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")
@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")

var saved_music_volume = 1.0
var saved_SFX_volume = 1.0
var mute_pressed: bool = false

func get_MusicID():
	return Music_Bus_ID

func get_SFXID():
	return SFX_Bus_ID

func get_MasterID():
	return Master_Bus_ID

func get_mute_state():
	return mute_pressed

func set_mute_state(value: bool):
	mute_pressed = value
	
# Funkcija išsaugoti reikšmę
func set_music_volume(value: float) -> void:
	saved_music_volume = value

# Funkcija gauti reikšmę
func get_music_volume() -> float:
	return saved_music_volume
	
# Funkcija išsaugoti reikšmę
func set_SFX_volume(value: float) -> void:
	saved_SFX_volume = value

# Funkcija gauti reikšmę
func get_SFX_volume() -> float:
	return saved_SFX_volume
