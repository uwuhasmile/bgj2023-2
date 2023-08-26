extends Node
class_name CheckpointManager


@export var current: Checkpoint


func revive(plr: Player) -> void:
	if (not is_instance_valid(current)): return
	current.teleport_here(plr)
