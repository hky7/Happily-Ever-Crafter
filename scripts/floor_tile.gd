extends TileSet

var in_motion = null
onready var tile = self
onready var ySort = null

func _on_Area2D_mouse_entered():
	if(game_controller.is_dragging):
		if is_valid_placement():
			draw_highlight()
		else:
			tile.modulate = Color(.77, .77, .255)

func draw_highlight():
	tile.modulate = Color(.37, .68, .25)

func _on_Area2D_mouse_exited():
	if(game_controller.is_dragging):
		tile.modulate = Color(1, 1, 1)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.is_action_pressed('click') and in_motion):
		if is_valid_placement():
			tile.modulate = Color(1, 1, 1)

func is_valid_placement():
	return str(game_controller.game_grid[game_controller.active_tile.tile_id].accessory_id) == null
