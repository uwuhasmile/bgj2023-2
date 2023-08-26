extends Node3D
class_name Checkpoint


@export var manager: CheckpointManager


func teleport_here(plr: Player) -> void:
	plr.global_position = global_position
	plr.control_rotation = global_rotation


func teleport_object_here(obj: NodePath) -> void:
	if (not has_node(obj) or not get_node(obj) is Node3D): return
	var node: Node3D = get_node(obj) as Node3D
	node.global_position = global_position
	node.global_rotation = global_rotation
	if (node is Player): (node as Player).control_rotation = global_rotation


func set_current() -> void:
	assert(is_instance_valid(manager))
	manager.current = self


func is_current() -> bool:
	assert(is_instance_valid(manager))
	return manager.current == self
