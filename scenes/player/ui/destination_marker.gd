extends Node3D

@export var movement_component: MovementComponent 
@export var input_handler: InputHandler 

var destination_marker: MeshInstance3D
var is_moving: bool = false

func _ready() -> void:
	input_handler.position_selected.connect(_on_position_selected)
	movement_component.destination_reached.connect(_hide_marker)
	movement_component.movement_stopped.connect(_hide_marker)
	movement_component.movement_interrupted.connect(_hide_marker)
	_init_marker()

func _on_position_selected(pos: Vector3) -> void:
	# Show marker at click position
	destination_marker.global_position = pos + Vector3(0, 0.05, 0) 
	destination_marker.visible = true

func _hide_marker() -> void:
	destination_marker.visible = false

func _init_marker() -> void:
	# Create the marker
	destination_marker = MeshInstance3D.new()
	# Make marker not dependent on the parent position
	destination_marker.top_level = true
	
	# Create a simple quad mesh
	var quad_mesh: QuadMesh = QuadMesh.new()
	quad_mesh.size = Vector2(0.5, 0.5)
	destination_marker.mesh = quad_mesh
	
	# Rotate to lay flat on ground (for Y-up world)
	destination_marker.rotation_degrees.x = -90
	
	# Create a simple material
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color(1, 1, 0, 0.7) # Yellow with transparency
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	destination_marker.material_override = material
	
	add_child(destination_marker)
	destination_marker.visible = false
