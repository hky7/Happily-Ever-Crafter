extends Node


func _on_new_game_btn_gui_input(ev):
	if ev.is_action_pressed('click'):
		get_tree().change_scene("res://scenes/new_game.tscn")


func _on_continue_btn_gui_input(ev):
	if ev.is_action_pressed('click'):
		game_controller._continue_game()
