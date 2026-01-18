extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
var actor: Node

func _ready():
	actor = get_parent()
	
	if not actor:
		push_error("StateMachine must be a child of of a vaid node!")
		return

	await get_tree().process_frame
	
	# Gather all child states
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.actor = actor # Pass reference to character
	
	# Start with initial state
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _input(event):
	if current_state:
		current_state.handle_input(event)

func change_state(new_state_name: String):
	if not states.has(new_state_name):
		push_error("State " + new_state_name + " does not exist!")
		return

	# Prevent changing to the same state
	if current_state && current_state.name == new_state_name:
		return
	
	print(new_state_name)

	if current_state:
		current_state.exit()
	
	current_state = states[new_state_name]
	current_state.enter()

func get_current_state_name() -> String:
	return current_state.name if current_state else ""
