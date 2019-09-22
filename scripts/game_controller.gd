extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");
# Variables
var db;
var reference_data;
var currentShopTypeId;
var playerShop;
var shopSize;
var shopId;
var is_dragging = null
var done_dragging = null
var moving_object = null
var active_tile = null
var game_grid = []
var shop_accessories = []
var floor_tile_grid;
var item_tile_grid;
var selected_accessory;
var selected_item;
var is_player_movable = false
var game_inventory;
var active_tiles = []
var is_ok_to_buy = false

func _ready():
	_get_files()		
	
func _get_files():
	var files = []
	var path = 'res://json'
	var dir = Directory.new()
	var json_data = {}
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var new_file = File.new()
			new_file.open('res://json/' + file, File.READ)
			var content = new_file.get_as_text()
			var name = file.split(".", true)
			json_data[name[0]] = JSON.parse(content).result
	

	dir.list_dir_end()

	reference_data = json_data

func save_game():
	db = SQLite.new();
	
	# Open the database
	if (not db.open_db("res://MedievalMerchant.db")):
		return;
	
	var result = db.query(str("UPDATE shops SET shop_space_level ='", playerShop.shop_space_level,"', shop_experience = '", playerShop.shop_experience, "', shop_gold = '", playerShop.shop_gold,"', shop_level = '", playerShop.shop_level,"', shop_rating = '", playerShop.shop_rating, "' WHERE shops.shop_id = '", playerShop.shop_id, "';"))
		
	if (result):
		for tile in game_grid:
			var grid_result = db.query(str("UPDATE shop_grid SET accessory_id ='", tile.accessory_id,"', skin_id = '", tile.skin_id, "', accessory_level = '", tile.accessory_level,"', tile_flip = '", tile.tile_flip, "', tile_vector_x = '", tile.tile_vector_x, "', tile_vector_y = '", tile.tile_vector_y, "', accessory_part = '", tile.accessory_part, "'  WHERE shop_grid.shop_id = '", playerShop.shop_id, "' AND shop_grid.tile_id = '", tile.tile_id, "';"))
			
			if (grid_result):
				continue
		
func _create_new_game(name):
	db = SQLite.new();
	
	# Open the database
	if (not db.open_db("res://MedievalMerchant.db")):
		return;
	
	var result = db.query(str("INSERT INTO shops (shop_name, shop_created_date, shop_last_modified_date, shop_space_level, shop_experience, shop_gold, shop_level, shop_rating) VALUES ('", name,"',", OS.get_unix_time(),",", OS.get_unix_time(),", 1, 0, 100, 1, 1);"))
	
	if(result):
		var newShop = db.fetch_array("SELECT MAX(shop_id) FROM shops");
		
		shopId = newShop[0].values()[0]
		
		var newGame = db.fetch_array(str("SELECT * FROM shops WHERE shops.shop_id = '", shopId, "';"))
	
		for game in newGame:
			var shop = {
				'shop_id': game['shop_id'],
				'shop_name': game['shop_name'],
				'shop_created_date': game['shop_created_date'],
				'shop_last_modified_date': game['shop_last_modified_date'],
				'shop_space_level': game['shop_space_level'],
				'shop_experience': game['shop_experience'],
				'shop_gold': game['shop_gold'],
				'shop_level': game['shop_level'],
				'shop_rating': game['shop_rating']	
				}
	
			playerShop = shop
		
		_create_new_game_grid()
		
		for tile in game_grid:
			var save_grid_result = db.query(str("INSERT INTO shop_grid (shop_id, tile_id, accessory_id, skin_id, accessory_level, tile_flip, tile_vector_x, accessory_part, tile_vector_y) VALUES ('", shopId, "', '", tile.tile_id, "', '", tile.accessory_id, "', '", tile.skin_id, "', '", tile.accessory_level,"', '", tile.tile_flip,"', '", tile.tile_vector_x,"', '", tile.accessory_part,"', '", tile.tile_vector_y, "')"))
			
			if (save_grid_result):
				continue
	
		get_tree().change_scene("res://scenes/shop.tscn")
		
	
func _create_new_game_grid():
	var shop_levels = reference_data.shop_level
	var columns = shop_levels[0].size + 1
	var rows = shop_levels[0].size + 1
	shopSize = shop_levels[0].size
	var index = 0
	
	for x in range (0, rows):
		for y in range (0, columns):
			var game_tile = {
				'tile_id': index,
				'shop_id': null,
				'accessory_id': null,
				'skin_id': null,
				'accessory_level': null,
				'tile_flip': 0,
				'tile_vector_x': null,
				'accessory_part': null,
				'tile_vector_y': null
			}
			
			game_grid.append(game_tile)
			index = index + 1
		
func _continue_game():
	db = SQLite.new();
	
	# Open the database
	if (not db.open_db("res://MedievalMerchant.db")):
		return;
		
	var result = db.fetch_array("SELECT * FROM shops ORDER BY shop_last_modified_date DESC LIMIT 1;")
	
	if (result and not result.empty()):
		for game in result:
			var shop = {
				'shop_id': game['shop_id'],
				'shop_name': game['shop_name'],
				'shop_created_date': game['shop_created_date'],
				'shop_last_modified_date': game['shop_last_modified_date'],
				'shop_space_level': game['shop_space_level'],
				'shop_experience': game['shop_experience'],
				'shop_gold': game['shop_gold'],
				'shop_level': game['shop_level'],
				'shop_rating': game['shop_rating']
				}
				
			playerShop = shop
			shopId = shop.shop_id
			for level in reference_data.shop_level: if(str(level.shop_level_id) == str(shop.shop_level)): shopSize = level.size
			_get_game_grid()
			get_tree().change_scene("res://scenes/shop.tscn")
			
func _get_game_grid():
	var grid_result = db.fetch_array(str("SELECT * FROM shop_grid WHERE shop_grid.shop_id = '", shopId,"';"))
	var grid = []
	
	if (grid_result):
		for grid_tile in grid_result:
			var tile = {
				'tile_id': grid_tile['tile_id'],
				'accessory_id': grid_tile['accessory_id'],
				'skin_id': grid_tile['skin_id'],
				'accessory_level': grid_tile['accessory_level'],
				'tile_flip': grid_tile['tile_flip'],
				'tile_vector_x': grid_tile['tile_vector_x'],
				'accessory_part': grid_tile['accessory_part'],
				'tile_vector_y': grid_tile['tile_vector_y']
			}
			
			grid.append(grid_tile)
		game_grid = grid
	
func _update_game_grid(cell_id, accessory):
		# Open the database
	var tile = game_grid[cell_id]
	if (not db.open_db("res://MedievalMerchant.db")):
		return;
		
	var result = db.query(str("UPDATE shop_grid SET tile_id ='", tile.tile_id,"', tile_vector_x = '", tile.tile_vector_x, "', accessory_part = '", tile.accessory_part,"', tile_vector_y = '", tile.tile_vector_y, "', accessory_id = '", accessory.accessory_id, "', skin_id = '", accessory.skin_id, "', tile_flip = '", tile.tile_flip,"' WHERE shops.shop_id = '", playerShop.shop_id, "' AND tile_id = '", tile.tile_id, "';"))
	
	return result

func _add_item_to_inventory(item):
	var result = null
	var row = db.fetch_array(str("SELECT * FROM shop_inventory WHERE shop_inventory.shop_id = '", playerShop.shop_id, "' AND shop_inventory.item_id = '", item.item_id, "' AND shop_inventory.item_enchant = '", item.item_enchant, "' AND shop_inventory.item_quality = '", item.item_quality, "'; "))
	if (!row):
		result = db.query(str("INSERT INTO shop_inventory (item_id, item_quantity, shop_id, item_quality, item_enchant) VALUES ('", item.item_id,"',1, '", item.shop_id,"', '", item.item_quality,"', '", item.item_enchant,"')"))
	else:
		result = db.query(str("UPDATE shop_inventory SET item_quantity = item_quantity + 1 WHERE shop_inventory.inventory_items_id = '", row[0].inventory_items_id, "';"))
				
	return result
	
func _get_game_resources():
	db = SQLite.new();
	
	# Open the database
	if (not db.open_db("res://MedievalMerchant.db")):
		return;
		
	var shop_resources = db.fetch_array(str("SELECT * FROM resource_inventory WHERE resource_inventory.shop_id = '", playerShop.shop_id,"';"));
	
	return shop_resources
	
func _set_current_shop_type(shopType):
	for type in reference_data.shop_types:
		if (type.shop_type == shopType):
			currentShopTypeId = type.shop_type_id
			
func _check_gold_amount(cost):
	return cost <= game_controller.playerShop.shop_gold

