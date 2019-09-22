extends Navigation2D

onready var navigationPolygon = get_node('NavigationPolygonInstance')
onready var current_navpoly_id = 1

func _update_path(object):
	var new_shape_polygon = PoolVector2Array()
	var col_polygon = object.get_node('polygon_cutout').get_polygon()
	var position = object.position
	var finalTransform = navigationPolygon.transform.inverse() * object.get_node('polygon_cutout').get_transform()
		
	for vector in col_polygon:
		new_shape_polygon.append(finalTransform.xform(vector) + position)

	navigationPolygon.navpoly.add_outline(new_shape_polygon)
	navigationPolygon.navpoly.make_polygons_from_outlines()
	rebuildNavPath()

func rebuildNavPath():
	navpoly_remove(current_navpoly_id)
	current_navpoly_id = navpoly_add(navigationPolygon.navpoly, navigationPolygon.get_relative_transform_to_parent(get_parent()))


func _on_buy_btn_accessory_buy_success():
	game_controller.moving_object._add_accessory()
