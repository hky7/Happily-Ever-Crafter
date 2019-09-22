extends Camera2D

# Camera control settings:
# key - by keyboard
# drag - by clicking mouse button, right mouse button by default;
# edge - by moving mouse to the window edge
# wheel - zoom in/out by mouse wheel
export (bool) var key = true
export (bool) var drag = true
export (bool) var edge = false
export (bool) var wheel = true

export (int) var zoom_out_limit = 100

# Camera speed in px/s.
export (int) var camera_speed = 450 

# Initial zoom value taken from Editor.
var camera_zoom = get_zoom()
onready var tile_map = get_parent().get_node('world').get_node('floor')

# Value meaning how near to the window edge (in px) the mouse must be,
# to move a view.
export (int) var camera_margin = 50

# It changes a camera zoom value in units... (?, but it works... it probably
# multiplies camera size by 1+camera_zoom_speed)
const camera_zoom_speed = Vector2(0.5, 0.5)

# Vector of camera's movement / second.
var camera_movement = Vector2()

# Previous mouse position used to count delta of the mouse movement.
var _prev_mouse_pos = null

# INPUTS

# Right mouse button was or is pressed.
var __mmbk = false
# Move camera by keys: left, top, right, bottom.
var __keys = [false, false, false, false]

func _ready():
	#set_pos(Global.Level.map_size*(Global.Level.tile_size)/2)
	set_h_drag_enabled(false)
	set_v_drag_enabled(false)
	set_enable_follow_smoothing(true)
	set_follow_smoothing(4)
	#set_fixed_process(true)
	set_process_unhandled_input(true)
	tile_map.fix_invalid_tiles()

func _process(delta):

	# Move camera by keys defined in InputMap (ui_left/top/right/bottom).
	if key:
		if __keys[0]:
			camera_movement.x -= camera_speed * delta
		if __keys[1]:
			camera_movement.y -= camera_speed * delta
		if __keys[2]:
			camera_movement.x += camera_speed * delta
		if __keys[3]:
			camera_movement.y += camera_speed * delta
	
	# Move camera by mouse, when it's on the margin (defined by camera_margin).
	if edge:
		if get_viewport().get_rect().size.x - get_viewport().get_mouse_position().x <= camera_margin:
			camera_movement.x += camera_speed * delta
		if get_viewport().get_mouse_position().x <= camera_margin:
			camera_movement.x -= camera_speed * delta
		if get_viewport().get_rect().size.y - get_viewport().get_mouse_position().y <= camera_margin:
			camera_movement.y += camera_speed * delta
		if get_viewport().get_mouse_position().y <= camera_margin:
			camera_movement.y -= camera_speed * delta
	
	# When RMB is pressed, move camera by difference of mouse position
	if drag and __mmbk and !game_controller.is_dragging:
		camera_movement = _prev_mouse_pos - get_viewport().get_mouse_position()
	
	# Update position of the camera.
	set_position(position + camera_movement * get_zoom())
	
	# Set camera movement to zero, update old mouse position.
	camera_movement = Vector2(0,0)
	_prev_mouse_pos = get_viewport().get_mouse_position()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		# Control by right mouse button.
		if event.is_pressed() and event.button_index ==  BUTTON_MIDDLE and drag:
			__mmbk = true
		else:
			__mmbk = false
		
		# Check if mouse wheel was used. Not handled by InputMap!
		if wheel:
			# Checking if future zoom won't be under 0.
			# In that cause engine will flip screen.
			if event.button_index == BUTTON_WHEEL_UP and\
			camera_zoom.x - camera_zoom_speed.x > 0 and\
			camera_zoom.y - camera_zoom_speed.y > 0:
				camera_zoom -= camera_zoom_speed
				set_zoom(camera_zoom)
				tile_map.fix_invalid_tiles()
				tile_map.update_dirty_quadrants()
			# Checking if future zoom won't be above zoom_out_limit.
			if event.button_index == BUTTON_WHEEL_DOWN and\
			camera_zoom.x + camera_zoom_speed.x < zoom_out_limit and\
			camera_zoom.y + camera_zoom_speed.y < zoom_out_limit:
				camera_zoom += camera_zoom_speed
				set_zoom(camera_zoom)
				tile_map.fix_invalid_tiles()
				tile_map.update_dirty_quadrants()
	# Control by keyboard handled by InpuMap.
	if event is InputEventKey and key:
		if event.is_action_pressed("ui_left"):
			__keys[0] = true
		if event.is_action_pressed("ui_up"):
			__keys[1] = true
		if event.is_action_pressed("ui_right"):
			__keys[2] = true
		if event.is_action_pressed("ui_down"):
			__keys[3] = true
		if event.is_action_released("ui_left"):
			__keys[0] = false
		if event.is_action_released("ui_up"):
			__keys[1] = false
		if event.is_action_released("ui_right"):
			__keys[2] = false
		if event.is_action_released("ui_down"):
			__keys[3] = false

func _on_cancel_btn_pressed():
	pass # Replace with function body.
