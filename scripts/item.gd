extends CanvasItem

func _on_item_container_gui_input(event):
	if event is InputEventMouseButton:
		game_controller.selected_item = self.name