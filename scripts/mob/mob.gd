extends CharacterBody3D

var selection_circle: MeshInstance3D

func _ready():
	add_to_group("mobs")
	_create_selection_circle()

func _create_selection_circle():
	# Create the mesh instance
	selection_circle = MeshInstance3D.new()
	var quad_mesh = QuadMesh.new()
	quad_mesh.size = Vector2(2.0, 2.0)
	selection_circle.mesh = quad_mesh
	
	# Rotate to face upward
	selection_circle.rotate_x(-PI / 2)
	
	# Position slightly above ground
	selection_circle.position.y = 0.05
	
	# Create shader material
	var shader_material = ShaderMaterial.new()
	var shader = Shader.new()
	shader.code = """
shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform vec4 circle_color : source_color = vec4(1.0, 0.0, 0.0, 0.6);
uniform float thickness : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec2 uv = UV * 2.0 - 1.0;
	float dist = length(uv);
	
	float circle = smoothstep(1.0, 1.0 - thickness, dist) - smoothstep(1.0 - thickness, 0.0, dist);
	
	ALBEDO = circle_color.rgb;
	ALPHA = circle * circle_color.a;
}
"""
	
	shader_material.shader = shader
	selection_circle.material_override = shader_material
	
	# Add as child FIRST
	add_child(selection_circle)
	
	# THEN set visibility
	selection_circle.visible = false

func select():
	if selection_circle:
		selection_circle.visible = true

func deselect():
	if selection_circle:
		selection_circle.visible = false

func take_damage(amount: float):
	# Placeholder for taking damage logic
	print(name, "took", amount, "damage.")

func sayHello():
	print("Hello from mob!")
