class_name SelectionCircle
extends Node3D

@export var line_thickness: float = 0.05  # Changed default to a visible value
@export var circle_radius: float = 0.6
@export var circle_color: Color = Color.RED

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	_create_circle_mesh()
	hide_circle()

func _create_circle_mesh() -> void:
	var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = circle_color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Make visible from both sides
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	
	# Draw circle using triangles to create thick lines
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	var segments: int = 64
	var half_thickness: float = line_thickness * 0.5  # Half the thickness for inner/outer radius

	for i: int in range(segments):
		var angle1: float = (float(i) / segments) * TAU
		var angle2: float = (float(i + 1) / segments) * TAU
		
		# Inner and outer vertices for this segment
		var inner1: Vector3 = Vector3(
			cos(angle1) * (circle_radius - half_thickness),
			0.05,
			sin(angle1) * (circle_radius - half_thickness)
		)
		var outer1: Vector3 = Vector3(
			cos(angle1) * (circle_radius + half_thickness),
			0.05,
			sin(angle1) * (circle_radius + half_thickness)
		)
		var inner2: Vector3 = Vector3(
			cos(angle2) * (circle_radius - half_thickness),
			0.05,
			sin(angle2) * (circle_radius - half_thickness)
		)
		var outer2: Vector3 = Vector3(
			cos(angle2) * (circle_radius + half_thickness),
			0.05,
			sin(angle2) * (circle_radius + half_thickness)
		)
		
		# First triangle
		immediate_mesh.surface_add_vertex(inner1)
		immediate_mesh.surface_add_vertex(outer1)
		immediate_mesh.surface_add_vertex(inner2)
		
		# Second triangle
		immediate_mesh.surface_add_vertex(inner2)
		immediate_mesh.surface_add_vertex(outer1)
		immediate_mesh.surface_add_vertex(outer2)
	
	immediate_mesh.surface_end()

func show_circle() -> void:
	visible = true

func hide_circle() -> void:
	visible = false