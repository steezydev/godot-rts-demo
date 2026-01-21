class_name Player
extends CharacterBody3D

@onready var state_machine: StateMachine = $StateMachine
@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var input_handler: InputHandler = $InputHandler
@onready var combat_component: CombatComponent = $CombatComponent
@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer

func _ready() -> void:
	input_handler.position_selected.connect(_on_position_selected)
	input_handler.target_selected.connect(_on_target_selected)
	input_handler.attack_triggered.connect(_on_attack_triggered)

	movement_component.destination_reached.connect(stop_moving)

	combat_component.chase_target.connect(_on_chase_target)
	combat_component.chase_stopped.connect(_on_chase_stopped)
	combat_component.attack_executed.connect(_on_attack_executed)
	combat_component.attack_stopped.connect(_on_attack_stopped)

func move(pos: Vector3) -> void:
	movement_component.move_to_position(pos)
	if state_machine.get_current_state_name() != 'RunningState':
		state_machine.change_state("RunningState")

func stop_moving() -> void:
	movement_component.stop_movement()
	if state_machine.get_current_state_name() != 'IdleState':
		state_machine.change_state("IdleState")

func _on_destination_reached() -> void:
	stop_moving()

func _on_position_selected(pos: Vector3) -> void:
	combat_component.stop_auto_attack()
	if (pos != Vector3.ZERO):
		move(pos)
	else:
		stop_moving()

func _on_target_selected(target: Mob) -> void:
	print("Target selected: ", target)
	combat_component.selected_target = target

func _on_attack_triggered() -> void:
	if combat_component.selected_target:
		combat_component.start_auto_attack()

func _on_chase_target(pos: Vector3) -> void:
	move(pos)

func _on_chase_stopped() -> void:
	stop_moving()

func _on_attack_executed(damage: float, target: CharacterBody3D) -> void:
	if state_machine.get_current_state_name() == 'RunningState':
		stop_moving()

	if state_machine.get_current_state_name() != 'AttackState':
		state_machine.change_state("AttackState")

	#TODO: Not sure if that's a good place to trigger the attack animation
	#TODO: But it seems to work for now and different animations can be passed based on the attack type
	_play_attack_animation()
	print("Attack executed: ", damage, " on ", target)

func _on_attack_stopped() -> void:
	# Reset any attack-related states
	if state_machine.get_current_state_name() == 'AttackState':
		state_machine.change_state("IdleState")

func _play_attack_animation() -> void:
	if animation_player:
		animation_player.stop()

		animation_player.play("Punch")

		var animation_length: float = animation_player.current_animation_length
		# Ajust animation speed to match attack speed
		animation_player.speed_scale = animation_length / combat_component.attack_cooldown
