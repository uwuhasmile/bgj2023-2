extends AudioStreamPlayer


@export var parent: CharacterBody3D
@export var min_speed: float = 4.0
@export var max_speed: float = 16.0
@export var min_volume_db: float = -50.0
@export var max_volume_db: float = 0.0
@export var easing_curve: float = 1.0 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (!is_instance_valid(parent)): return
	var speed_squared: float = parent.velocity.length_squared()
	if (speed_squared > min_speed * min_speed):
		if (not playing): playing = true
		var value: float = (speed_squared - min_speed * min_speed) /\
			(max_speed * max_speed - min_speed * min_speed)
		value = ease(value, easing_curve)
		volume_db = value * (max_volume_db - min_volume_db) + min_volume_db
	else: playing = false
	
