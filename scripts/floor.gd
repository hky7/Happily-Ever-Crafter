extends Node

onready var columns = game_controller.shopSize + 1
onready var rows = game_controller.shopSize + 1

func _ready():
	var floor_tile = load('res://object_templates/wood_tile.tscn')
	var index = 0
	
	
	for x in range (0, rows):
		for y in range (0, columns):
			var floor_tile_inst = floor_tile.instance()
			var size = floor_tile_inst.texture.get_size()
			#floor_tile_inst.position = Vector2(((x * (size.x - 1) * .5) + (y * (size.x - 1) * .5)), (y * (size.y - 6) * .5) - (x * (size.y - 6) * .5) + 150)
			floor_tile_inst.position = Vector2(((x * (size.x - 5) * .5) + (y * (size.x - 5) * .5)), (y * (size.y - 15) * .5) - (x * (size.y - 15) * .5) + 150)
			floor_tile_inst.name = str(index)
			floor_tile_inst.z_index = 0
			floor_tile_inst.get_node('test_label').text = floor_tile_inst.name
			add_child(floor_tile_inst)
			index = index + 1


	