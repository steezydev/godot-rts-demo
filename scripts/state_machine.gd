class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
var actor: Node

func _ready() -> void:
	actor = get_parent()
	
	if not actor:
		push_error("StateMachine must be a child of of a vaid node!")
		return

	await get_tree().process_frame
	
	# Gather all child states
	for child: State in get_children():
		if child is State:
			states[child.name] = child
			child.actor = actor # Pass reference to character
	
	# Start with initial state
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func change_state(new_state_name: String) -> void:
	if not states.has(new_state_name):
		push_error("State " + new_state_name + " does not exist!")
		return
	
	print(new_state_name)

	if current_state:
		current_state.exit()
	
	current_state = states[new_state_name]
	current_state.enter()

func get_current_state_name() -> String:
	if current_state:
		return current_state.name
	return ""
