extends CanvasLayer


@onready var first := $first as AnimatedSprite2D
@onready var second := $second as AnimatedSprite2D
@onready var third := $third as AnimatedSprite2D
@onready var fourth := $fourth as AnimatedSprite2D
@onready var fifth := $fifth as AnimatedSprite2D
@onready var sixth := $sixth as AnimatedSprite2D

var all
func _ready():
	all = [first, second, third, fourth, fifth, sixth]
	for heart in all:
		heart.visible = false
	
func set_max_hp(amount):
	for i in range(0, floor(amount/4)):
		all[i].visible = true
		
func set_hp(amount):
	var i = 0
	while i < floor(amount/4):
		all[i].play("4")
		i+=1
	amount -= floor(amount/4)*4
	if i != 6:
		all[i].play(str(amount))
		i+=1
		while i < all.size():
			all[i].play("0")
			i+=1
