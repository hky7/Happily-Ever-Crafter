extends Node

var isClicked = false
var newBody = null

func open_shop_menu():
	if isClicked:
		isClicked = false
		game_controller._set_current_shop_type(get_parent().get_name())
		var shopNode = get_node('/root/main_scene/shop_canvas/shop_popup_panel')
		shopNode.popup()

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if isClicked:
		open_shop_menu()	
		newBody = body

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('click'):
		isClicked = true
		if not newBody == null:
			if (newBody.position - newBody.target).length() < 35:
				open_shop_menu()


func _on_Area2D_area_shape_exited(area_id, area, area_shape, self_shape):
	newBody = null


func _on_Area2D_area_entered(area):
	print(area)
