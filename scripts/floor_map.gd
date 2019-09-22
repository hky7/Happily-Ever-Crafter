extends TileMap

onready var columns = int(game_controller.shopSize)
onready var rows = int(game_controller.shopSize)
onready var world = get_node('/root/main_scene/world')

func _ready():
	var count = 0
	var tile_grid = []
	
	for x in range (0, columns):
		for y in range (0, rows):
			set_cell(x, y, 2)
			game_controller.game_grid[count].tile_vector_x = x
			game_controller.game_grid[count].tile_vector_y = y
			count += 1
			
	update_dirty_quadrants()
	_load_game_grid()

func _load_game_grid():
	var tiles = []
	
	for tile in game_controller.game_grid:
		if (tile.accessory_id != null):
			for accessory in game_controller.reference_data.shop_accessories:
				if (str(tile.accessory_id) == str(accessory.shop_accessory_id) && str(tile.accessory_part) == '1'):
					_add_accessory_to_grid(tile, accessory)

func _add_accessory_to_grid(tile, accessory):
	var accessory_name = 'accessory_' + accessory.shop_accessory_name
	var accessory_to_load = load('res://accessory_scenes/' + accessory.shop_accessory_name +'.tscn').instance()
	accessory_to_load.position = map_to_world(Vector2(tile.tile_vector_x, tile.tile_vector_y)) + cell_size/4
	accessory_to_load.flip_h = tile.tile_flip
	world.add_child(accessory_to_load)
	call_deferred(world._update_path(accessory_to_load))
	