extends Node

@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")
@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")

const MainMenu = preload("res://Audio/Music/MainMenuwav.wav")

var saved_music_volume = 1.0
var saved_SFX_volume = 1.0
var mute_pressed: bool = false
var current_music: AudioStreamPlayer = null
	
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
	

# Reference to the existing AudioStreamPlayer node with settings applied

func play_music(music_stream: AudioStream):
	# Stop current music if it's playing
	if current_music != null and current_music.playing:
		current_music.stop()
	
	# Set the new music stream and play it with the existing settings
	if current_music != null:
		current_music.stream = music_stream
		current_music.play()
	
func play_with_random_pitch(audio_player: AudioStreamPlayer, min_pitch: float = 0.8, max_pitch: float = 1.2) -> void:
	# Sugeneruojame atsitiktinį pitch ir nustatome jį grotuvui
	audio_player.pitch_scale = randf_range(min_pitch, max_pitch)
	# Paleidžiame garsą
	audio_player.play()
	
func play_with_random_pitch2D(audio_player: AudioStreamPlayer2D, distance: int, min_pitch: float = 0.8, max_pitch: float = 1.2) -> void:
	# Sugeneruojame atsitiktinį pitch ir nustatome jį grotuvui
	audio_player.pitch_scale = randf_range(min_pitch, max_pitch)
	# Paleidžiame garsą
	audio_player.max_distance = distance
	audio_player.play()
