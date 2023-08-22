extends Node3D


@export var node: Node3D


func _process(_delta: float) -> void:
	if (!is_instance_valid(node)): return
	global_transform = node.global_transform
