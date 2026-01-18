extends Node
class_name State

# Reference to the character
var actor: Node

# Called when entering this state
func enter():
	pass

# Called every frame while in this state
func update(delta: float):
	pass

# Called every physics frame while in this state
func physics_update(delta: float):
	pass

# Called when exiting this state
func exit():
	pass

# Handle input events
func handle_input(event: InputEvent):
	pass
