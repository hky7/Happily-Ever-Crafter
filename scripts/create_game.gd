extends Node

func _on_create_btn_pressed():
	var gameName = get_node('new_game_name').get_text()
	
	game_controller._create_new_game(gameName)
