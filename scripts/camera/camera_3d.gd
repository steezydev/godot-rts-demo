extends Camera3D

@export var target: Node3D
@export var offset: Vector3 = Vector3(10, 15, 10)
@export var follow_speed: float = 5.0

# func _ready():
# 	# Set isometric angle
# 	rotation_degrees = Vector3(-50, 45, 0)

func _process(delta: float) -> void:
	if target:
		# Calculate where camera should be
		var target_pos: Vector3 = target.global_position + offset

		# Smoothly move camera there
		global_position = global_position.lerp(target_pos, follow_speed * delta)
