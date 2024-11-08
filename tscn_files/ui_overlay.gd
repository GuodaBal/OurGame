extends CanvasLayer


@onready var first := $first as AnimatedSprite2D
@onready var second := $second as AnimatedSprite2D
@onready var third := $third as AnimatedSprite2D

var hearts
var full

func _ready():
	full = [first, second, third]
	hearts = [first, second, third]


func remove_HP(amount):
	while(amount > 0):
		match hearts[-1].animation:
			"four":
				hearts[-1].play("three")
			"three":
				hearts[-1].play("two")
			"two":
				hearts[-1].play("one")
			"one":
				hearts[-1].play("zero")
				hearts.pop_back()
		amount=-1
func add_HP(amount):
	while(amount > 0):
		match hearts[-1].animation:
			"three":
				hearts[-1].play("four")
			"two":
				hearts[-1].play("three")
			"one":
				hearts[-1].play("two")
			"four":
				var lastHeart = true
				for heart in full:
					if heart not in hearts:
						hearts.append(heart)
						lastHeart = false
						break
				if !lastHeart:
					hearts[-1].play("one")
				print_debug(hearts[-1])
		amount-=1
