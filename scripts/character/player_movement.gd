extends Node

@onready var character = get_parent()

func _physics_process(delta):
	if not character.selected_position:
		return

	var direction = (character.selected_position - character.global_position)
	var distance = direction.length()
	
	if distance > character.stopping_distance:
		direction = direction.normalized()
		character.velocity = direction * character.move_speed
		character.move_and_slide()
		
		# Rotate to face direction
		var target_rotation = atan2(direction.x, direction.z)
		character.rotation.y = lerp_angle(character.rotation.y, target_rotation, character.rotation_speed * delta)
	else:
		EventBus.position_selected.emit(Vector3.ZERO)
