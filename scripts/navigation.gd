extends Navigation2D

export(float) var CHARACTER_SPEED = 200.0
var path = []

# The 'click' event is a custom input action defined in
# Project > Project Settings > Input Map tab
func _input(event):
	if not event.is_action_pressed('click'):
		return
	if (!game_controller.is_player_movable):
		_update_navigation_path($merchant.position, get_local_mouse_position())


func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class
	# it returns a PoolVector2Array of points that lead you from the
	# start_position to the end_position
	path = get_simple_path(start_position, end_position, true)
	# The first point is always the start_position
	# We don't need it in this example as it corresponds to the character's position
	path.remove(0)
	set_process(true)


func _process(delta):
	var walk_distance = CHARACTER_SPEED * delta
	move_along_path(walk_distance)


func move_along_path(distance):
	var last_point = $merchant.position
	for _index in range(path.size()):
		var distance_between_points = last_point.distance_to(path[0])
		# the position to move to falls between two points
		if distance <= distance_between_points and distance >= 0.0:
			$Character.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			break
		# the character reached the end of the path
		elif distance < 0.0:
			$merchant.position = path[0]
			set_process(false)
			break
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)