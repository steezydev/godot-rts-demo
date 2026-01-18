extends Node3D

func _ready() -> void:
	visible = false
	EventBus.position_selected.connect(_on_position_selected)

func _on_position_selected(target_position: Vector3):
	if target_position == Vector3.ZERO:
		_hide_marker()
		return
		
	_set_marker(target_position)

func _set_marker(target_position: Vector3):
	global_position = target_position + Vector3(0, 0.05, 0)
	visible = true

func _hide_marker():
	visible = false
