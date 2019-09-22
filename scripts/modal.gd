extends Node

onready var modal = get_node('/root/main_scene/crafting_panel/shop_popup_panel')
onready var craft_items = load('res://scripts/craft_items.gd')

func _on_craft_btn_pressed():
	modal.hide()
	craft_items.crate_item(game_controller.selected_item)

func _on_close_btn_pressed():
	modal.hide()
