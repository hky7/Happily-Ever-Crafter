extends TileMap

onready var columns = game_controller.shopSize.size
onready var rows = game_controller.shopSize.size

func _ready():
	var corner = get_tileset().find_tile_by_name('corner')
	var left_wall = get_tileset().find_tile_by_name('left_wall')
	var right_wall = get_tileset().find_tile_by_name('right_wall')
	
	for x in range (0, columns):
		for y in range (0, rows):
			if (x == 0 and y == 0):
				set_cell(x, y, corner)
			elif (x == 0):
				set_cell(x, y, left_wall)
			elif (y == 0):
				set_cell(x, y, right_wall)