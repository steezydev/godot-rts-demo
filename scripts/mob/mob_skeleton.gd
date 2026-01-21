class_name MobSkeleton
extends Mob

@onready var health_component: HealthComponent = $HealthComponent

@onready var health_bar: TextureProgressBar = $UI/SubViewport/HealthBar


func _ready() -> void:
	add_to_group("mobs")
	health_component.died.connect(_on_died)

	health_component.health_changed.connect(_on_health_changed)
	print(health_bar)

func get_health_component() -> HealthComponent:
	return health_component

func _on_health_changed(current: float, maximum: float) -> void:
	print('Health changed: ',  health_component.get_health_percentage() * 100.0)
	health_bar.value = current / maximum * 100.0 if maximum > 0 else 0.0

func _on_died() -> void:
	queue_free()
