extends TileMap

onready var columns = game_controller.shopSize
onready var rows = game_controller.shopSize
var tileSet = get_tileset()

func _ready():
	var count = 0
	var tile_grid = []
	
	for x in range (0, columns):
		for y in range (0, rows):
			tileSet.create_tile(count)
			tileSet.tile_set_texture(count, null)
			set_cell(x, y, count)
			count += 1
			
	update_dirty_quadrants()
	game_controller.item_tile_grid = tile_grid
	
func _add_accessory(cell_id, cell):
	var new_accessory = game_controller.moving_object
	#new_accessory.position = map_to_world(cell) + Vector2(20, 20)
	new_accessory.position = map_to_world(cell)
	get_parent()._update_path(cell_id, cell)
	