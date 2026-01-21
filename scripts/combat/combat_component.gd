class_name CombatComponent
extends Node

signal chase_target(target_position: Vector3)
signal chase_stopped()
signal attack_executed(damage: float, target: Node3D)

@export var actor: CharacterBody3D
@export var attack_range: float = 2.0
@export var attack_cooldown: float = 1.0 
@export var attack_damage: float = 100.0

var selected_target: Mob #TODO: Can be another Player too, but those will have similar api
var is_auto_attacking: bool = false
var time_since_last_attack: float = 0.0
var is_chasing: bool = false

func _ready() -> void:
	time_since_last_attack = attack_cooldown

func _physics_process(delta: float) -> void:
	time_since_last_attack = min(time_since_last_attack + delta, attack_cooldown)

	if is_auto_attacking and selected_target:
		# Check if target is still valid
		if not is_instance_valid(selected_target):
			stop_auto_attack()
			return
		
		var can_reach: bool = actor.position.distance_to(selected_target.position) <= attack_range
		
		if !can_reach:
			chase_target.emit(selected_target.position)
			is_chasing = true
		else:
			if is_chasing:
				chase_stopped.emit()
				is_chasing = false
			
			# Check if enough time has passed for next attack
			if time_since_last_attack >= attack_cooldown:
				execute_attack()
				time_since_last_attack = 0.0  # Reset timer


func start_auto_attack() -> void:
	if (!selected_target):
		return

	# Only allow immediate first attack if we haven't attacked recently
	if !is_auto_attacking:
		is_auto_attacking = true
		if time_since_last_attack < attack_cooldown:
			pass
		else:
			time_since_last_attack = attack_cooldown

func stop_auto_attack() -> void:
	is_auto_attacking = false
	#time_since_last_attack = 0.0

# Execute the attack sequence, but not the damage dealing
func execute_attack() -> void:
	if (!selected_target):
		return

	attack_executed.emit(attack_damage, selected_target)

# Separate function to deal damage, called via animation event
func deal_attack_damage() -> void:
	if (!selected_target):
		return

	selected_target.get_health_component().take_damage(attack_damage)