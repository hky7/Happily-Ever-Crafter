extends Sprite

var is_dragging = null
onready var tileMap = get_parent().get_parent().get_node('world').get_node('floor')
onready var world = get_node('/root/main_scene/world')
onready var front_ray = get_node('front_ray')
onready var back_ray = get_node('back_ray')
var active_tile_one = null
var active_tile_one_v = null
var prev_active_tile_one_v = null
var prev_active_tile_two_v = null
var active_tile_two = null
var active_tile_two_v = null
var accessory_id;

func _process(delta):
	if (is_dragging):
		position = get_global_mouse_position()
		if (front_ray.is_colliding() && back_ray.is_colliding()):
			var mouse_position = tileMap.world_to_map(tileMap.to_local(position))
			active_tile_one_v = tileMap.world_to_map(tileMap.to_local(front_ray.get_collision_point()))
			active_tile_two_v = tileMap.world_to_map(tileMap.to_local(back_ray.get_collision_point()))
			if (active_tile_one_v != active_tile_two_v && active_tile_one_v != prev_active_tile_one_v && active_tile_two_v != prev_active_tile_two_v):
				prev_active_tile_one_v = active_tile_one_v
				prev_active_tile_two_v = active_tile_two_v		
				
			if (mouse_position):
				position = tileMap.map_to_world(mouse_position) + tileMap.cell_size/4
				self_modulate.a = .75
		
func _get_tile_id(tile_v):
	var result = null
	for tile in game_controller.game_grid:
		if int(tile.tile_vector_x) == int(tile_v.x) && int(tile.tile_vector_y) == int(tile_v.y):
			result = tile
			break
	return result

func _unhandled_input(event):
	if (is_dragging):
		if event.is_action_pressed('click'):
			active_tile_one = _get_tile_id(active_tile_one_v)
			active_tile_two = _get_tile_id(active_tile_two_v)
			game_controller.is_dragging = null
			drop_object()
		#if event.is_action_pressed('mouse_scroll'):
			#set_flip_h(!self.flip_h)
		
func is_valid_placement(tile_to_check):
	var id = tile_to_check.accessory_id
	return id

func drop_object():
	if (active_tile_one && is_valid_placement(active_tile_one) && active_tile_two && is_valid_placement(active_tile_two)):
		self_modulate.a = 1
		is_dragging = null
		
		game_controller.done_dragging = true
		game_controller.is_ok_to_buy = true
		var new_accessory = game_controller.moving_object
		new_accessory.position = position
		active_tile_one.accessory_id = new_accessory.accessory_id
		active_tile_one.accessory_part = 1
		active_tile_two.accessory_id = new_accessory.accessory_id
		active_tile_two.accessory_part = 2
		world._update_path(new_accessory)
	
func _add_accessory():
	game_controller.game_grid[active_tile_one.tile_id] = active_tile_one
	game_controller.game_grid[active_tile_two.tile_id] = active_tile_two
	front_ray.enabled = false
	back_ray.enabled = false