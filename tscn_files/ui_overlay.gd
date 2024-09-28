extends CanvasLayer


@onready var first := $first as AnimatedSprite2D
@onready var second := $second as AnimatedSprite2D
@onready var third := $third as AnimatedSprite2D

var hearts

func _ready():
	hearts = [first, second, third]


func remove_HP():
	match hearts[-1].animation:
		"four":
			hearts[-1].play("three")
		"three":
			hearts[-1].play("two")
		"two":
			hearts[-1].play("one")
		"one":
			hearts[-1].queue_free()
			hearts.pop_back()
