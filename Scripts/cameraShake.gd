extends Camera2D
# Intensyvumas nuo 0.0 iki 1.0
var shake_strength: float = 0.0
# Kuo didesnis, tuo greičiau nurimsta
var shake_decay: float = 5.0
# Koks maximalus atstumas (pikseliais) kamera gali svyruoti
var shake_max_offset: float = 10.0

var _original_position: Vector2

func _ready() -> void:
	# Išsaugome pradinę kameros poziciją
	_original_position = position

func _process(delta: float) -> void:
	if shake_strength > 0.01:
		# Randf_range(-1,1) duoda reikšmę tarp -1 ir 1
		var offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * shake_strength * shake_max_offset
		position = _original_position + offset
		# Palaipsniui mažiname drebėjimo stiprumą
		shake_strength = lerp(shake_strength, 0.0, delta * shake_decay)
	else:
		position = _original_position

# Iškviesk šią funkciją, kad pradėtum drebėjimą
func shake(amount: float = 1.0) -> void:
	shake_strength = amount
