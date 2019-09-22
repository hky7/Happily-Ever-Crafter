extends Node

onready var parent = get_node('shop_info_texture')

func _ready():
	parent.get_node('shop_info_name').set_text(game_controller.playerShop.shop_name)
	parent.get_node('shop_info_exp').set_text(String(game_controller.playerShop.shop_experience))
	parent.get_node('shop_info_gold_amt').set_text(String(game_controller.playerShop.shop_gold))