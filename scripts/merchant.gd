extends KinematicBody2D

export (int) var speed = 100
export(float) var CHARACTER_SPEED = 200.0
var path = []
var target = get_global_position()

# The 'click' event is a custom input action defined in
# Project > Project Settings > Input Map tab
func _unhandled_input(event):
	if not event.is_action_pressed('click'):
		return
	elif (event.is_action_pressed('click') and game_controller.done_dragging):
		game_controller.done_dragging = null
		return
	if (!game_controller.is_player_movable):
		target = get_global_mouse_position()	
		_update_navigation_path(position, target)


func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class
	# it returns a PoolVector2Array of points that lead you from the
	# start_position to the end_position
	var world = get_parent().get_parent().get_node('world')
	path = world.get_simple_path(start_position, end_position, true)
	# The first point is always the start_position
	# We don't need it in this example as it corresponds to the character's position
	path.remove(0)
	set_process(true)


func _process(delta):
	var walk_distance = CHARACTER_SPEED * delta
	move_along_path(walk_distance)


func move_along_path(distance):
	var last_point = position
	for _index in range(path.size()):
		var distance_between_points = last_point.distance_to(path[0])
		# the position to move to falls between two points
		if distance <= distance_between_points and distance >= 0.0:
			position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			break
		# the character reached the end of the path
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)