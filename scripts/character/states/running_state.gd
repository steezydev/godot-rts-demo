extends State

var animation_player: AnimationPlayer

#TODO: This should not be here
@export var min_animation_speed: float = 0.5
@export var max_animation_speed: float = 2.0

func enter():
	actor.velocity = Vector3.ZERO
	
	# Get animation player when entering the state
	if not animation_player:
		animation_player = actor.get_node("Model/AnimationPlayer")
		
	if animation_player:
		var speed_ratio = actor.move_speed / actor.base_move_speed
		animation_player.speed_scale = clamp(
			speed_ratio,
			min_animation_speed,
			max_animation_speed
		)
		animation_player.play("Run")
