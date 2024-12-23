extends Node

@onready var Music_Bus_ID = AudioServer.get_bus_index("Music")
@onready var SFX_Bus_ID = AudioServer.get_bus_index("SFX")
@onready var Master_Bus_ID = AudioServer.get_bus_index("Master")

const MainMenu = preload("res://Audio/Music/MainMenuwav.wav")
var audio_player = null
var audio_playerF = null
var audio_playerW = null
var audio_playerM = null
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
	

func play_forest_sound():
	if audio_playerM and audio_playerM.playing:
		audio_playerM.stop()
	if audio_playerW and audio_playerW.playing:
		audio_playerW.stop()
	if audio_playerF and audio_playerF.playing:
		audio_playerF.stop()	
	if not audio_player:  # Sukuriame tik jei dar nėra
		audio_player = AudioStreamPlayer.new()
		audio_player.stream = preload("res://Audio/Music/forest.wav")
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada
		audio_player.bus = "Music"
		add_child(audio_player)
	if not audio_player.playing:  # Patikriname, ar garsas jau negroja
		audio_player.play()
		print("Garsas paleistas.")
	else:
		print("Garsas jau groja.")
func stop_forest_sound():
	if audio_player and audio_player.playing:  # Tikriname, ar groja
		audio_player.stop()
		print("Garsas sustabdytas.")
	else:
		print("Nėra grojančio garso.")
		
func play_forestfire_sound():
	if audio_playerM and audio_playerM.playing:
		audio_playerM.stop()
	if audio_playerW and audio_playerW.playing:
		audio_playerW.stop()
	if audio_player and audio_player.playing:
		audio_player.stop()
	if not audio_playerF:  # Sukuriame tik jei dar nėra
		audio_playerF = AudioStreamPlayer.new()
		audio_playerF.stream = preload("res://Audio/Music/ForestFire_mixdown.wav")
		audio_playerF.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		audio_playerF.bus = "Music"	
		add_child(audio_playerF)
	if not audio_playerF.playing:  # Patikriname, ar garsas jau negroja
		audio_playerF.play()
		print("Garsas paleistas.")
	else:
		print("Garsas jau groja.")

func stop_forestfire_sound():
	if audio_playerF and audio_playerF.playing:  # Tikriname, ar groja
		audio_playerF.stop()
		print("Garsas sustabdytas.")
	else:
		print("Nėra grojančio garso.")
		

func play_water_sound():
	if audio_playerM and audio_playerM.playing:
		audio_playerM.stop()
	if audio_player and audio_player.playing:
		audio_player.stop()
	if audio_playerF and audio_playerF.playing:
		audio_playerF.stop()
	if not audio_playerW:  # Sukuriame tik jei dar nėra
		audio_playerW = AudioStreamPlayer.new()
		audio_playerW.stream = preload("res://Audio/Music/WaterArea.wav")
		audio_playerW.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada		
		audio_playerW.bus = "Music"
		add_child(audio_playerW)
		if not audio_playerW.playing:  # Patikriname, ar garsas jau negroja
			audio_playerW.play()
			print("Garsas paleistas.")
		else:
			print("Garsas jau groja.")
func stop_water_sound():
	if audio_playerW and audio_playerW.playing:  # Tikriname, ar groja
		audio_playerW.stop()
		print("Garsas sustabdytas.")
	else:
		print("Nėra grojančio garso.")
		
func play_mainmenu():
	if audio_player and audio_player.playing:
		audio_player.stop()
	if audio_playerW and audio_playerW.playing:
		audio_playerW.stop()
	if audio_playerF and audio_playerF.playing:
		audio_playerF.stop()	
	if not audio_playerM:  # Sukuriame tik jei dar nėra
		audio_playerM = AudioStreamPlayer.new()
		audio_playerM.stream = preload("res://Audio/Music/MainMenuwav.wav")
		audio_playerM.process_mode = Node.PROCESS_MODE_ALWAYS  # Nustatome, kad procesas vyktų visada	
		audio_playerM.bus = "Music"	
		add_child(audio_playerM)
		if not audio_playerM.playing:  # Patikriname, ar garsas jau negroja
			audio_playerM.play()
			print("Garsas paleistas.")
		else:
			print("Garsas jau groja.")
func stop_mainmenu():
	if audio_playerM and audio_playerM.playing:  # Tikriname, ar groja
		audio_playerM.stop()
		print("Garsas sustabdytas.")
	else:
		print("Nėra grojančio garso.")
func play_with_random_pitch(audio_playerL: AudioStreamPlayer, min_pitch: float = 0.8, max_pitch: float = 1.2) -> void:
	# Sugeneruojame atsitiktinį pitch ir nustatome jį grotuvui
	audio_playerL.pitch_scale = randf_range(min_pitch, max_pitch)
	# Paleidžiame garsą
	audio_playerL.play()
	
func play_with_random_pitch2D(audio_playerL: AudioStreamPlayer2D, distance: int, min_pitch: float = 0.8, max_pitch: float = 1.2) -> void:
	# Sugeneruojame atsitiktinį pitch ir nustatome jį grotuvui
	audio_playerL.pitch_scale = randf_range(min_pitch, max_pitch)
	# Paleidžiame garsą
	audio_playerL.max_distance = distance
	audio_playerL.play()
