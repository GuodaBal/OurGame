extends Node2D

func _ready():
	randomize()
	start_lightning_loop()

func start_lightning_loop():
	# Paleidžia fono užduotį, kuri žaibuoja atsitiktiniais intervalais
	lightning_loop()

func lightning_loop() -> void:
	await get_tree().create_timer(randf_range(6.0, 15.0)).timeout
	flash_lightning()
	lightning_loop()  # Rekursyviai kviečia save
	
func flash_lightning():
	var env = $"../WorldEnvironment".environment
	var original_exposure = env.tonemap_exposure

	for i in range(randi() % 2 + 1):  # 1 arba 2 blyksniai
		env.tonemap_exposure = 3.5
		await get_tree().create_timer(randf_range(0.1, 0.25)).timeout
		env.tonemap_exposure = original_exposure
		await get_tree().create_timer(randf_range(0.05, 0.15)).timeout
