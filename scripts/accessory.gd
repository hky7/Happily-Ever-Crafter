extends Area2D

func _on_Area2D_body_entered(body):
	if(game_controller.selected_accessory == get_parent().name && !game_controller.is_dragging):
		game_controller.currentShopTypeId = get_parent().accessory_id
		var shopNode = get_node('/root/main_scene/crafting_panel/shop_popup_panel')
		shopNode.popup()
		game_controller.selected_accessory = null
		
func _on_click_area_input_event(viewport, event, shape_idx):
	if(game_controller.selected_accessory == get_parent().name && !game_controller.is_dragging):
		game_controller.selected_accessory = get_parent().name