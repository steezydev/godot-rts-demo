extends Node

@export var max_health: float = 2100
@export var health: float = 2100
@export var attack_range: float = 2.0
@export var auto_attacks_per_minute: float = 60.0  # 60 attack per minute
@export var attack_damage: float = 100.0

var character: CharacterBody3D
#TODO: Not sure if it's good to have animation player in the combat module
var animation_player: AnimationPlayer

var is_auto_attacking: bool = false
var selected_target: Node3D = null

var time_since_last_attack: float = 0.0
var attack_cooldown: float = 1.0  # Will be calculated from auto_attacks_per_minute


func _ready() -> void:
	self.character = get_parent()
	animation_player = character.get_node("Model/AnimationPlayer")
	_update_attack_cooldown()

func _update_attack_cooldown() -> void:
	# Convert attacks per minute to seconds between attacks
	attack_cooldown = 60.0 / auto_attacks_per_minute

func start_auto_attack(target: Node3D) -> void:
	self.is_auto_attacking = true
	self.selected_target = target
	# Reset timer to allow immediate first attack
	time_since_last_attack = attack_cooldown

func stop_auto_attack() -> void:
	self.is_auto_attacking = false
	time_since_last_attack = 0.0

func perform_auto_attack() -> void:
	if is_auto_attacking and selected_target and is_instance_valid(selected_target):
		_play_attack_animation()

		# Deal damage
		if selected_target.has_method("take_damage"):
			selected_target.take_damage(attack_damage)

func set_attack_rate(new_rate: float) -> void:
	auto_attacks_per_minute = new_rate
	_update_attack_cooldown()

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		die()

func get_health_percentage() -> float:
	return health / max_health

func die() -> void:
	print("Character has died.")
	stop_auto_attack()
	# queue_free()

func _play_attack_animation() -> void:
	if animation_player:
		animation_player.stop()

		animation_player.play("SwordSlash")

		var animation_length = animation_player.current_animation_length
		# Ajust animation speed to match attack speed
		animation_player.speed_scale = animation_length / attack_cooldown

func _physics_process(delta: float) -> void:
	if is_auto_attacking and selected_target:
		# Check if target is still valid
		if not is_instance_valid(selected_target):
			stop_auto_attack()
			return
		
		var can_reach = character.position.distance_to(selected_target.position) <= attack_range
		
		if !can_reach:
			character.move(selected_target.position)
		else:
			if character.state_machine.get_current_state_name() == 'RunningState':
				character.stop_moving()
			
			# Update attack timer
			time_since_last_attack += delta
			
			# Check if enough time has passed for next attack
			if time_since_last_attack >= attack_cooldown:
				perform_auto_attack()
				time_since_last_attack = 0.0  # Reset timer
