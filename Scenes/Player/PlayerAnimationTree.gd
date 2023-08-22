extends AnimationTree


@export var parent: CharacterBody3D
@export var max_speed: float = 8.0
@export var min_fall_speed: float = 8.0
@export var max_fall_speed: float = 20.0
@export var fall_speed_easing_curve: float = 1.0


func _process(_delta: float) -> void:
	if (!is_instance_valid(parent)): return
	var speed_squared: float = parent.velocity.length_squared()
	set(&"parameters/Movement/blend_position", speed_squared / max_speed * max_speed)
	set(&"parameters/Falling/blend_position",
		ease((speed_squared - min_fall_speed * min_fall_speed) /\
		(max_fall_speed * max_fall_speed - min_fall_speed * min_fall_speed),
		fall_speed_easing_curve)
	)
