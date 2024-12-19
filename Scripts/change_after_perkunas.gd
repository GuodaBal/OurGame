extends Node2D
#@onready var audio = $Background.stream
@onready var levelBe := $BeforePerkunas as TileMapLayer
@onready var levelAf := $AfterPerkunas as TileMapLayer

# After defeating perkunas path is unlbocked
func _ready() -> void:
	AudioManager.play_forest_sound()
	AudioManager.stop_water_sound()
	AudioManager.stop_forestfire_sound()
	if GlobalVariables.PerkunasDone:
		levelBe.visible = false
		levelBe.collision_enabled = false
		levelAf.visible = true
		levelAf.visible = true
	else:
		levelBe.visible = true
		levelBe.collision_enabled = true
		levelAf.visible = false
		levelAf.visible = false
