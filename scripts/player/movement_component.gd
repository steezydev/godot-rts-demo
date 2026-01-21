class_name MovementComponent
extends Node

signal movement_started(destination: Vector3, speed: float)
signal movement_stopped
signal destination_reached

@export var actor: CharacterBody3D 
@export var stopping_distance: float = 0.1
@export var move_speed: float = 5.0
@export var rotation_speed: float = 10.0

var selected_position: Vector3
var is_moving: bool = false

func _physics_process(delta: float) -> void:
	if not selected_position:
		return

	var direction: Vector3 = (selected_position - actor.global_position)
	var distance: float = direction.length()
	
	if distance > stopping_distance:
		direction = direction.normalized()
		actor.velocity = direction * move_speed
		actor.move_and_slide()
		
		# Rotate to face direction
		var target_rotation: float = atan2(direction.x, direction.z)
		actor.rotation.y = lerp_angle(actor.rotation.y, target_rotation, rotation_speed * delta)
	else:
		destination_reached.emit()
		stop_movement()

func move_to_position(position: Vector3) -> void:
	selected_position = position
	is_moving = true
	movement_started.emit(position, move_speed)

func stop_movement() -> void:
	selected_position = Vector3.ZERO
	is_moving = false
	if actor:
		actor.velocity = Vector3.ZERO
	movement_stopped.emit()