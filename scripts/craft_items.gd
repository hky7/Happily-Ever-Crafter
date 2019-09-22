extends Node

onready var modal = get_node('/root/main_scene/shop_canvas/shop_popup_panel')
onready var timer;
onready var timer_label = get_node('/root/main_scene/YSort/crafting_time')
var item_to_craft = null
var recipe = null

func _on_TextureButton_pressed():
	if(_is_craftable()):
		game_controller.is_player_movable = true
		modal.hide()
		_craft_item()
	
func _get_recipe_ingredients():
	var ingredients = []
	
	for recipe in game_controller.reference_data.recipe_ingredients:
		if str(recipe.recipe_id) == str(item_to_craft.item_recipe_id):
			ingredients.append(recipe)
			
	return ingredients
	
func _get_resource(resources, item_id):
	var res = null
	
	for resource in resources:
		if str(item_id) == str(resource.item_id):
			res = resource
			break
			
	return res
				
func _is_craftable():
	item_to_craft = _get_item(get_parent().name)
	recipe = _get_item_recipe(item_to_craft)
	var ingredients = _get_recipe_ingredients()
	var resources = game_controller._get_game_resources()
	var is_craftable = true
	
	for ingredient in ingredients:
		var resource = _get_resource(resources, ingredient.item_id)
		if (int(resource.item_quantity) - int(ingredient.item_quantity) < 0):
			is_craftable = false
			break
		else:
			resource.item_quantity = int(resource.item_quantity) - int(ingredient.item_quantity)
	
	return is_craftable
		

func _get_item(item_id):
	var selected_item = null
	
	for item in game_controller.reference_data.items:
		if (str(item.item_id) == str(item_id)):
			selected_item = item
			break
	
	return selected_item
	
func _craft_item():
	if (item_to_craft):
		#TODO determine quality of item
		_start_recipe_timer(recipe)
		
	#TODO add in quality check based on shop level and shop rating, for now default to normal
	
func _get_item_recipe(item):
	var current_recipe = null
	
	for recipe in game_controller.reference_data.recipes:
		if (recipe.recipe_id == item.item_recipe_id):
			current_recipe = recipe
			
	return current_recipe
	

func _start_recipe_timer(recipe):
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(int(recipe.recipe_time_to_complete))
	timer.connect("timeout", self, "on_recipe_complete")
	get_parent().get_parent().add_child(timer)
	timer.start()
	
func on_recipe_complete():
	print('complete!')
	game_controller.is_player_movable = false
	var crafted_item = {
		'item_id': item_to_craft.item_id,
		'item_quantity': 1,
		'shop_id': game_controller.playerShop.shop_id,
		'item_quality': 1, #TODO determine item quality
		'item_enchant': 0 #TODO check for enchant
		}
	game_controller._add_item_to_inventory(crafted_item)
	get_parent().get_parent().remove_child(timer)

func _process(delta):
	if (game_controller.is_player_movable and timer):
		timer_label.set_text(str(timer.get_time_left()))
	
	
	# be able to open inventory and see finished product once timer is finished
