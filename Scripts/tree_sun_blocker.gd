extends AnimatableBody2D

@onready var animation := $AnimationPlayer as AnimationPlayer 
@onready var particles = $GPUParticles2D
@onready var particles2 = $GPUParticles2D2
@onready var shader_material = $AnimatedSprite2D2.material as ShaderMaterial
var can_burn = false

var growth_progress := 0.0  # nuo 0 iki 1
var frame_offset := 0.0

func _ready() -> void:
	#animation.play("RESET")
	pass

func grow():
	animation.play("grow")
	await animation.animation_finished
	
		# Shader material shader pridėjimas
	var shader := load("res://Game_Sprites/Shaders/branchWiggle.gdshader")
	var mat := ShaderMaterial.new()
	mat.shader = shader
	material = mat  # arba $Sprite.material jei sprite atskirai
	
	particles.emitting = true
	particles2.emitting = true
	

		
func burn():
	if can_burn:
		particles.emitting = false
		particles2.emitting= false 
		animation.play("burning")
		
		get_parent().unblock_sun()
		await animation.animation_finished
		can_burn = false
	#queue_free()
