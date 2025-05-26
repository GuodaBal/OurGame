extends CanvasLayer

@onready var first := $first as AnimatedSprite2D
@onready var second := $second as AnimatedSprite2D
@onready var third := $third as AnimatedSprite2D
@onready var fourth := $fourth as AnimatedSprite2D
@onready var fifth := $fifth as AnimatedSprite2D
@onready var sixth := $sixth as AnimatedSprite2D


#Visuals
@onready var aura := $aura as Sprite2D
@onready var aura2 := $aura2 as Sprite2D
@onready var environment := $WorldEnvironment as WorldEnvironment
@onready var damage_material := preload("res://Shaders/shake.tres")
@onready var heal_material := preload("res://Shaders/heal.tres")

var all

var healing = false
var taking_damage = false

func _ready():
	all = [first, second, third, fourth, fifth, sixth]
	for heart in all:
		heart.visible = false

func _process(delta: float) -> void:
	for heart in all:
		heart.material.set_shader_parameter("current_time", Time.get_ticks_msec() / 1000.0)
	if aura.modulate.a >= 0.39:
		healing = false
	if healing:
		aura.modulate.a = lerp(aura.modulate.a, 0.6, delta * 1.0)
	else:
		aura.modulate.a = lerp(aura.modulate.a, 0.0, delta * 3.0)
	if aura2.modulate.a >= 1.2:
		taking_damage = false
	if taking_damage:
		aura2.modulate.a = lerp(aura2.modulate.a, 1.4, delta * 2.5)
	elif GlobalVariables.currentHP > 4:
		aura2.modulate.a = lerp(aura2.modulate.a, 0.0, delta * 2.5)
	if GlobalVariables.currentHP <= 2:
		var current = environment.environment.adjustment_brightness
		var next = 0.2 * GlobalVariables.currentHP + 0.4
		environment.environment.adjustment_brightness = lerp(current, next, delta * 3.0)
		environment.environment.adjustment_saturation = lerp(current, next, delta * 3.0)
	else:
		var current = environment.environment.adjustment_brightness
		environment.environment.adjustment_brightness = lerp(current, 1.0, delta * 1.0)
		environment.environment.adjustment_saturation = lerp(current, 1.0, delta * 1.0)
	
func set_max_hp(amount):
	for i in range(0, floor(amount/4)):
		all[i].visible = true
	GlobalVariables.maxHP = amount
		
func set_hp(amount):
	if amount > GlobalVariables.currentHP:
		amount = clamp(amount, 0, GlobalVariables.maxHP)
		var index
		index = amount / 4 - 1
		if int(amount) % 4 > 0 && all[index + 1].visible:
			index += 1
		heal(all[index])
	elif amount < GlobalVariables.currentHP:
		var last
		for heart in all:
			if heart.visible && heart.animation != "0":
				last = heart
		take_damage(last)
	GlobalVariables.currentHP = amount
	var i = 0
	while i < floor(amount/4):
		all[i].play("4")
		i+=1
	amount -= floor(amount/4)*4
	if i != 6:
		all[i].play(str(int(amount)))
		i+=1
		while i < all.size():
			all[i].play("0")
			i+=1
			

#Methods for visuals
func heal(heart):
	healing = true
	heart.material = heal_material.duplicate()
	heart.material.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0)


func take_damage(heart):
	taking_damage = true
	heart.material = damage_material.duplicate()
	heart.material.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0)
