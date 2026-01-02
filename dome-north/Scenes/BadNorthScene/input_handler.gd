extends Node
var selected_unit: Player3DClickMove = null 

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var result = raycast_from_mouse(event.position)
		if result:
			var collider = result.collider
			
			if collider is Player3DClickMove:
				if selected_unit:
					selected_unit.select_unit(false)
				selected_unit = collider
				selected_unit.select_unit(true)
			
			elif selected_unit:
				selected_unit.move_to_position(result.position)

func raycast_from_mouse(mouse_pos):
	var cam = get_viewport().get_camera_3d()
	var from = cam.project_ray_origin(mouse_pos)
	var dir = cam.project_ray_normal(mouse_pos)
	var space_state = cam.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, from + dir * 1000.0)
	return space_state.intersect_ray(query)
