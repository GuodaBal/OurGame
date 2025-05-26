extends Camera2D

var shakeFade = 5.0

var currentStrength = 0.0

func _process(delta: float) -> void:
	if currentStrength > 0:
		currentStrength = lerpf(currentStrength, 0, shakeFade*delta)
		offset = Vector2(randf_range(-currentStrength, currentStrength), randf_range(-currentStrength, currentStrength) - 100)

func shake(shakeStrength = 10.0):
	currentStrength = shakeStrength
