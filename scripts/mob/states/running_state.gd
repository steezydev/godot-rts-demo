extends State

var animation_player: AnimationPlayer

func enter():
	actor.velocity = Vector3.ZERO
	
	# Get animation player when entering the state
	if not animation_player:
		animation_player = actor.get_node("Model/AnimationPlayer")
	
	if animation_player:
		animation_player.play("Run")

func physics_update(delta):
	# Could add subtle idle movements here
	pass
