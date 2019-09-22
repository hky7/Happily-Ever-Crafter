extends CanvasItem

signal accessory_buy_success

onready var accesoryPanel = get_node('/root/main_scene/accessory_window/accessory_control/accessory_popup_panel')
onready var accessory_confirmation = get_node('/root/main_scene/accessory_confirmation/confirmation_control/confirmation_popup')
onready var world = get_node('/root/main_scene/world')
onready var tileMap = get_node('/root/main_scene/world/floor')

func _ready():
	_load_game_grid()
		

func _load_game_grid():
	var tiles = []
	
	for tile in game_controller.game_grid:
		if (tile.accessory_id != null):
			for accessory in game_controller.shop_accessories:
				if (tile.accessory_id == accessory.shop_accessory_id && tile.accessory_part == 1):
					_add_accessory_to_grid(tile, accessory)
			
	
func _add_accessory_to_grid(tile, accessory):
	var accessory_name = 'accessory_' + accessory.shop_accessory_name
	var accessory_to_load = load('res://' + accessory.shop_accessory_name +'.tscn').instance()
	accessory_to_load.position = tileMap.map_to_world(Vector2(tile.tile_vector_x, tile.tile_vector_y)) + tileMap.cell_size/4
	accessory_to_load.flip_h = tile.tile_flip
	world.add_child(accessory)
	world.update_path(accessory_to_load)
	
func _set_up_accessory(accessory, accessory_name, id):
	game_controller.is_player_movable = false
	accessory_confirmation.visible = true
	var currentPosition = get_global_mouse_position()
	accessory.position.x = currentPosition.x
	accessory.position.y = currentPosition.y
	world.add_child(accessory)
	accessory.is_dragging = true
	accessory.accessory_id = id
	accessory.name = accessory_name
	game_controller.moving_object = accessory


func _on_blacksmith_button_pressed():
	var accessory_name = 'accessory_blacksmith'
	var accessory = load('res://accessory_scenes/blacksmith.tscn').instance()
	_set_up_accessory(accessory, accessory_name, 2)


func _on_tailor_btn_pressed():
	var accessory_name = 'accessory_tailor'
	var accessory = load('res://accessory_scenes/tailor.tscn').instance()
	var accessory_id = 1
	for shop_accessory in game_controller.reference_data.shop_accessories:
		if shop_accessory.shop_accessory_name == 'Tailor' : accessory_id = shop_accessory.shop_accessory_id
	_set_up_accessory(accessory, accessory_name, accessory_id)


func _on_accessory_btn_pressed():
	accesoryPanel.visible = !accesoryPanel.visible


func _on_buy_btn_pressed():
	var accessory_cost = game_controller.reference_data.shop_accessories[game_controller.moving_object.accessory_id].shop_accessory_cost
	
	if (game_controller.is_ok_to_buy && accessory_cost && game_controller._check_gold_amount(accessory_cost)):
		emit_signal('accessory_buy_success')
		game_controller.is_player_movable = true
		accessory_confirmation.visible = false
		print('bought!')


func _on_cancel_btn_pressed():
	accessory_confirmation.visible = false
	game_controller.is_player_movable = true
	world.remove_child(game_controller.moving_object)
	game_controller.moving_object = null
	print('canceled!')
	