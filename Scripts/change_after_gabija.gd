extends Node2D

@onready var before := $BeforeGabija as TileMapLayer
@onready var after := $AfterGabija as TileMapLayer

func _ready() -> void:
	if GlobalVariables.GabijaDone:
		before.visible = false
		before.collision_enabled = false
	else:
		after.visible = false
		after.collision_enabled = false
