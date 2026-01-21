extends Node

# Player
signal position_selected(position: Vector3)
signal target_selected(target: Node3D)
signal attack_triggered()

# Combat
signal attack_performed(damage: float, target: Node3D)