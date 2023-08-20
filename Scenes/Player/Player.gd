extends CharacterBody3D


@export_category("Player: Movement")
@export_range(0, 1000.0) var max_acceleration: float
@export_range(0, 1000.0) var max_decceleration: float
@export_range(0, 1000.0) var move_speed: float
@export_range(0, 1000.0) var jump_height: float
@export_range(0.0, 10.0) var jump_peak_time: float
@export_range(0.0, 10.0) var jump_fall_time: float
@export_range(0.0, 2000.0) var max_horizontal_air_speed: float
@export_range(0.0, 2000.0) var max_vertical_air_speed: float
@export_range(0.0, 1.0) var air_control: float

"""Player input variables"""
var _wish_dir: Vector2
var _wants_to_jump: bool
var _mouse_delta: Vector2

"""Jump variables"""
var _jump_velocity: float
var _jump_gravity: float
var _fall_gravity: float

@onready var _coyote_time: float = ProjectSettings.get_setting(&"game/input/coyote_time", 0.1)
@onready var _jump_buffering_time: float = ProjectSettings.get_setting(&"game/input/jump_buffering", 0.1)

var _current_coyote_time: float = NAN
var _current_jump_buffer_time: float = 0.0

"""Children"""
@onready var _camera: Node3D = $CameraBone


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	_calculate_input()
	_update_jump(delta)


func _physics_process(delta: float) -> void:
	_jump_velocity = (2.0 * jump_height) / jump_peak_time
	_jump_gravity = (-2.0 * jump_height) / (jump_peak_time * jump_peak_time)
	_fall_gravity = (-2.0 * jump_height) / (jump_fall_time * jump_fall_time)
	
	var wish_dir: Vector3 = (global_transform.basis * Vector3(_wish_dir.x, 0.0, _wish_dir.y)).normalized();
	
	if (is_on_floor()):
		_current_coyote_time = _coyote_time
		var accelerator: float = max_acceleration if wish_dir.length_squared() > 0.0 else max_decceleration
		var target: Vector3 = wish_dir * move_speed if wish_dir.length_squared() > 0.0 else Vector3.ZERO
		velocity = velocity.move_toward(target, accelerator * delta)
	else:
		velocity.y += _calculate_gravity() * delta
		velocity.y = clampf(velocity.y, -max_vertical_air_speed, max_vertical_air_speed)
		var target: Vector3 = wish_dir * max_horizontal_air_speed \
			if wish_dir.length_squared() > 0.0 else velocity
		target.y = velocity.y
		velocity = velocity.move_toward(target, max_acceleration * delta * air_control)
	
	if (_should_jump()):
		velocity.y = _jump_velocity
		_current_coyote_time = NAN
		_current_jump_buffer_time = 0.0
	elif (_wants_to_jump and !is_on_floor()):
		_current_jump_buffer_time = _jump_buffering_time
	
	_wants_to_jump = false
	move_and_slide()


func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		var sensitivity: float = ProjectSettings.get_setting(&"game/input/mouse_sensitivity", 1.0) as float
		var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
		rotate_y(deg_to_rad(-mouse_event.relative.x) * sensitivity)
		if (is_instance_valid(_camera)):
			_camera.rotation.x -= deg_to_rad(mouse_event.relative.y) * sensitivity
			_camera.rotation.x = clampf(_camera.rotation.x, -PI * 0.5, PI * 0.5)


func _calculate_input() -> void:
	_wish_dir = Input.get_vector(&"move_lft", &"move_rgt", &"move_fwd", &"move_bwd")
	if (Input.is_action_just_pressed(&"jump")): _wants_to_jump = true


func _calculate_gravity() -> float:
	return _jump_gravity if velocity.y > 0.0 else _fall_gravity


func _update_jump(delta: float) -> void:
	if (!is_on_floor() and !is_nan(_current_coyote_time) and _current_coyote_time > 0.0):
		_current_coyote_time = maxf(_current_coyote_time - delta, 0.0)
	if (_current_jump_buffer_time > 0.0):
		_current_jump_buffer_time = maxf(_current_jump_buffer_time - delta, 0.0)


func _should_jump() -> bool:
	if (is_on_floor()): return _wants_to_jump or _current_jump_buffer_time > 0.0
	else: return _wants_to_jump and _current_coyote_time > 0.0
	
