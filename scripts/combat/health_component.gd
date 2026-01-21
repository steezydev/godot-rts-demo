class_name HealthComponent
extends Node

@export var max_health: float = 2100.0
var current_health: float

signal health_changed(current: float, maximum: float)
signal died()
signal damage_taken(amount: float)

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	print("Damage taken: ", amount)
	current_health = max(0, current_health - amount)
	damage_taken.emit(amount)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func get_health_percentage() -> float:
	return current_health / max_health if max_health > 0 else 0.0