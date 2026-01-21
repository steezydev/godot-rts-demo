class_name CombatComponent
extends Node

signal attack_cooldown_ready()
signal target_out_of_range(pos: Vector3)
signal attack_executed(damage: float, target: Node3D)

@export var actor: CharacterBody3D
@export var attack_range: float = 2.0
@export var auto_attacks_per_minute: float = 60.0  # 60 attack per minute
@export var attack_damage: float = 100.0

var is_auto_attacking: bool = false
var selected_target: Mob

var time_since_last_attack: float = 0.0
var attack_cooldown: float = 1.0  # Will be calculated from auto_attacks_per_minute


func _ready() -> void:
	_update_attack_cooldown()

func _update_attack_cooldown() -> void:
	# Convert attacks per minute to seconds between attacks
	attack_cooldown = 60.0 / auto_attacks_per_minute

#TODO: There is a bug, when spamming the attack button, the cooldown is not respected
func start_auto_attack() -> void:
	if (!selected_target):
		return

	is_auto_attacking = true
	# Reset timer to allow immediate first attack
	time_since_last_attack = attack_cooldown

func stop_auto_attack() -> void:
	is_auto_attacking = false
	time_since_last_attack = 0.0

func execute_attack() -> void:
	if (!selected_target):
		return

	attack_executed.emit(attack_damage, selected_target)

func hit_target() -> void:
	print("Hit target called")
	if (!selected_target):
		return

	selected_target.get_health_component().take_damage(attack_damage)

func set_attack_rate(new_rate: float) -> void:
	auto_attacks_per_minute = new_rate
	_update_attack_cooldown()

func _physics_process(delta: float) -> void:
	if is_auto_attacking and selected_target:
		# Check if target is still valid
		if not is_instance_valid(selected_target):
			stop_auto_attack()
			return
		
		var can_reach: bool = actor.position.distance_to(selected_target.position) <= attack_range
		
		if !can_reach:
			target_out_of_range.emit(selected_target.position)
		else:
			# if actor.state_machine.get_current_state_name() == 'RunningState':
			# 	actor.stop_moving()
			
			# Update attack timer
			time_since_last_attack += delta
			
			# Check if enough time has passed for next attack
			if time_since_last_attack >= attack_cooldown:
				execute_attack()
				time_since_last_attack = 0.0  # Reset timer
