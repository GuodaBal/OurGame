extends Node

@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")
@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")

var beat_Gabija: bool = false
var saved_music_volume = 1.0
var saved_SFX_volume = 1.0
var mute_pressed: bool = false
var current_music : AudioStreamPlayer = null

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
	
# Nuoroda į dabartinį muzikos grotuvo objektą


func play_music(music_stream: AudioStream):
	# Sustabdo dabartinę muziką, jei tokia groja
	if current_music and current_music.playing:
		current_music.stop()
	
	# Sukuria naują muzikos grotuvo objektą ir paleidžia naują muziką
	current_music = AudioStreamPlayer.new()
	add_child(current_music)
	current_music.stream = music_stream
	current_music.play()
