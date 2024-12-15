extends AnimatedSprite2D

func _ready() -> void:
	play("idle")
	await get_parent().get_parent().get_node("AnimationPlayer").animation_finished
	if !GlobalVariables.PerkunasDone:
		get_parent().get_node("MainCharacter").change_zoom(0.8)
		DialogueManager.show_dialogue_balloon(load("res://Dialogue/perkunas.dialogue"), "meet", false)
		GlobalVariables.PerkunasDone = true
		get_parent().get_node("MainCharacter").change_zoom(Settings.zoom)
	else:
		DialogueManager.show_dialogue_balloon(load("res://Dialogue/perkunas.dialogue"), "return", false)
