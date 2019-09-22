extends TileMap

onready var columns = game_controller.shopSize
onready var rows = game_controller.shopSize

func _ready():
	var wood_floor = get_tileset().find_tile_by_name('wood_floor')
	var count = 0
	var tileSet = get_tileset()
	var tile_grid = []
	
	
	for x in range (0, columns):
		for y in range (0, rows):
			set_cell(x, y, wood_floor)
			var cell = {
				'id': count,
				'x': x,
				'y': y
			}
			tile_grid.append(cell)
			count += 1
			
	
	game_controller.item_tile_grid = tile_grid

		