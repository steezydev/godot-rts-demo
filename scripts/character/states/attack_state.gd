extends State

var animation_player: AnimationPlayer

func enter():
	# Get animation player when entering the state
	if not animation_player:
		animation_player = actor.get_node("Model/AnimationPlayer")
	
	if animation_player:
		animation_player.play("SwordSlash")
