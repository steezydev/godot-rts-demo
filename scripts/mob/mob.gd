@abstract
class_name Mob
extends CharacterBody3D

#var selection_circle: MeshInstance3D

@abstract
func get_health_component() -> HealthComponent

@abstract
func set_selected(is_selected: bool) -> void