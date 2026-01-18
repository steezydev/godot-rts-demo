extends CharacterBody3D

@export var move_speed: float = 5.0
@export var base_move_speed: float = 5.0

@export var rotation_speed: float = 10.0
@export var stopping_distance: float = 0.1

@onready var state_machine = $StateMachine
@onready var running_state = $StateMachine/RunningState
@onready var player_combat = $PlayerCombat

var selected_position: Vector3
var selected_target: Node3D

func _ready() -> void:
	EventBus.position_selected.connect(_on_position_selected)
	EventBus.target_selected.connect(_on_target_selected)
	EventBus.attack_triggered.connect(_on_attack_triggered)

func _on_position_selected(pos: Vector3):
	player_combat.stop_auto_attack()
	move(pos)

func _on_attack_triggered():
	_attack(selected_target)

func _attack(target: Node3D):
	if target:
		player_combat.start_auto_attack(target)
		print("Attacking ", target.name)

func _on_target_selected(target: Node3D):
	_select_target(target)

func _select_target(target: Node3D):
	selected_target = target
	selected_target.select()

func move(pos: Vector3):
	selected_position = pos

	if selected_position == Vector3.ZERO:
		state_machine.change_state("IdleState")
		return
		
	state_machine.change_state("RunningState")

func stop_moving():
	selected_position = Vector3.ZERO
	state_machine.change_state("IdleState")
