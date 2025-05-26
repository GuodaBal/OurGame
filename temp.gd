extends TileMapLayer


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		set_cell(local_to_map(get_local_mouse_position()), 2, Vector2(7,3))
		set_cells_terrain_connect(get_used_cells(), 0, 0)
		print_debug(get_local_mouse_position())
		print_debug(local_to_map(get_local_mouse_position()))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_cell(local_to_map(Vector2(0,0)), 2, Vector2(7,3))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
