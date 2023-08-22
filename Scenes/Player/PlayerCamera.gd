extends Node3D


@export var parent: Player


func _process(_delta: float) -> void:
	if (!is_instance_valid(parent)): return
	rotation.x = parent.control_rotation.x
