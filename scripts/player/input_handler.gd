class_name InputHandler
extends Node

signal position_selected(position: Vector3)
signal target_selected(target: Mob)
signal attack_triggered()

var camera: Camera3D

func _ready() -> void:
	camera = get_viewport().get_camera_3d()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_mouse_input(event as InputEventMouseButton)
		return

	if event.is_action_pressed("auto_attack"):
		_handle_attack_input()

func _handle_attack_input() -> void:
	attack_triggered.emit()

func _handle_mouse_input(event: InputEventMouseButton) -> void:
	# Only raycast to ground for movement on right mouse button click by default
	var mask: int = 2
	if event.button_index == MOUSE_BUTTON_LEFT:
		# Raycast to ground and mobs (+other targets) on left mouse button click
		mask = 10

	var result: Dictionary = _raycast_to_world(event.position, mask)
	print(result)

	if !result || !result.collider:
		return

	# Select target if it's a Mob
	if result.collider is Mob:
		target_selected.emit(result.collider)
		return

	# Move to ground position
	if result.collider.is_in_group("ground"):
		position_selected.emit(result.position)
		return

func _raycast_to_world(screen_pos: Vector2, mask: int) -> Dictionary:
	var from: Vector3 = camera.project_ray_origin(screen_pos)
	var to: Vector3 = from + camera.project_ray_normal(screen_pos) * 1000

	var space_state: PhysicsDirectSpaceState3D = get_viewport().get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)

	query.collision_mask = mask # Ground and Mob 2 + 8

	return space_state.intersect_ray(query)
