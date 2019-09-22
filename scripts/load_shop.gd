extends Node

# Variables
var shop_items = [];
var previous_shop_id = null

func _get_shop_items():
	shop_items = [];
	
	for item in game_controller.reference_data.items:
		if (str(item.shop_type_id) == str(game_controller.currentShopTypeId)):
			shop_items.append(item);

func _on_PopupPanel_about_to_show():
	if (!game_controller.is_player_movable):
		_get_shop_items()
		_populate_shop_panel()
	
func _populate_shop_panel():
	var itemListGrid = find_node('item_list_grid')
	var itemScene = load('res://object_templates/item4.tscn')
	
	for i in itemListGrid.get_children():
		itemListGrid.remove_child(i)
	
	for item in shop_items:
		var itemSceneInstance = itemScene.instance()
		itemSceneInstance.name = String(item.item_id)
		itemSceneInstance.get_node('item_name').set_text(item.item_name)
		itemSceneInstance.get_node('item_info_container').get_node('item_value_amt').set_text(String(item.item_base_value))
		itemSceneInstance.get_node('item_info_container').get_node('item_description').set_text(item.item_description)
		
		itemListGrid.add_child(itemSceneInstance)
	

