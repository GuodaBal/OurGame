extends Area2D

@onready var start := $Start as Sprite2D
@onready var afterGabija := $AfterGabija as Sprite2D
@onready var afterMedeina := $AfterMedeina as Sprite2D
@onready var afterPerkunas := $AfterPerkunas as Sprite2D

func _ready() -> void:
	monitoring = false
	if GlobalVariables.PerkunasDone:
		monitoring = true
		afterPerkunas.visible = true
	elif GlobalVariables.MedeinaDone:
		afterMedeina.visible = true
	elif GlobalVariables.GabijaDone:
		afterGabija.visible = true
	else:
		start.visible = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().current_scene.switchLevel("boss_level_angel")
