extends Node

class_name InputHandler

var camera: Camera3D

func _ready():
	camera = get_viewport().get_camera_3d()

func _input(event):
	if event is InputEventMouseButton:
		_handle_mouse_input(event)
		return

	if event.is_action_pressed("auto_attack"):
		_handle_attack_input()

func _handle_attack_input():
	EventBus.attack_triggered.emit()

func _handle_mouse_input(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT:
		_handle_mouse_input_left(event)
		return

	if event.button_index == MOUSE_BUTTON_RIGHT:
		_handle_mouse_input_right(event)
		return

func _handle_mouse_input_right(event: InputEventMouseButton):
	# Only raycast to ground for movement on right mouse button click
	var mask = 2
	var result = _raycast_to_world(event.position, mask)
	print(result)

	if !result || !result.collider:
		return

	if result.collider.is_in_group("ground"):
		EventBus.position_selected.emit(result.position)

func _handle_mouse_input_left(event: InputEventMouseButton):
	# Raycast to ground and mobs (+other targets) on left mouse button click
	var mask = 10
	var result = _raycast_to_world(event.position, mask)
	print(result)

	if !result || !result.collider:
		return

	if result.collider.is_in_group("mobs"):
		EventBus.target_selected.emit(result.collider)
		return
	
	if result.collider.is_in_group("ground"):
		EventBus.position_selected.emit(result.position)
		return

func _raycast_to_world(screen_pos: Vector2, mask: int):
	var from = camera.project_ray_origin(screen_pos)
	var to = from + camera.project_ray_normal(screen_pos) * 1000
	
	var space_state = get_viewport().get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)

	query.collision_mask = mask # Ground and Mob 2 + 8

	return space_state.intersect_ray(query)
