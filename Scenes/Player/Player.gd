extends CharacterBody3D
class_name Player


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
@export_range(-1000.0, 1000.0) var min_wall_jump_vertical_speed: float
@export_range(1, 10) var max_wall_jumps: int

"""Player input variables"""
var _wish_dir: Vector2
var _wants_to_jump: bool
var rotation_velocity: Vector3
var control_rotation_velocity : Vector3
var control_rotation: Vector3

"""Jump variables"""
var _jump_velocity: float
var _jump_gravity: float
var _fall_gravity: float
var jumped: bool

@onready var _coyote_time: float = ProjectSettings.get_setting(&"game/input/coyote_time", 0.1)
@onready var _jump_buffering_time: float = ProjectSettings.get_setting(&"game/input/jump_buffering", 0.1)

var _current_coyote_time: float = NAN
var _current_jump_buffer_time: float = 0.0
var _current_wall_jumps: int = 0


func _ready() -> void:
	control_rotation = Vector3(0.0, global_rotation.y, 0.0)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	_calculate_input()
	_update_jump(delta)
	control_rotation += rotation_velocity * delta
	control_rotation.x = clampf(control_rotation.x, -PI * 0.5, PI * 0.5)
	rotation.y = control_rotation.y
	rotation_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	_jump_velocity = (2.0 * jump_height) / jump_peak_time
	_jump_gravity = (-2.0 * jump_height) / (jump_peak_time * jump_peak_time)
	_fall_gravity = (-2.0 * jump_height) / (jump_fall_time * jump_fall_time)
	
	jumped = false
	
	var wish_dir: Vector3 = (global_transform.basis * Vector3(_wish_dir.x, 0.0, _wish_dir.y)).normalized();
	
	if (is_on_floor()):
		_current_wall_jumps = 0
		_current_coyote_time = 0.0
		var accelerator: float = max_acceleration if wish_dir.length_squared() > 0.0 else max_decceleration
		var target: Vector3 = wish_dir * move_speed if wish_dir.length_squared() > 0.0 else Vector3.ZERO
		velocity = velocity.move_toward(target, accelerator * delta)
	else:
		if (velocity.y < 0.0 and _current_coyote_time == 0.0):
			_current_coyote_time = _coyote_time
		velocity.y += _calculate_gravity() * delta
		velocity.y = clampf(velocity.y, -max_vertical_air_speed, max_vertical_air_speed)
		var target: Vector3 = wish_dir * max_horizontal_air_speed \
			if wish_dir.length_squared() > 0.0 else velocity
		target.y = velocity.y
		velocity = velocity.move_toward(target, max_acceleration * delta * air_control)
	
	if (_should_jump()):
		velocity.y = _jump_velocity
		_current_coyote_time = -1.0
		_current_jump_buffer_time = 0.0
		jumped = true
	elif (_should_wall_jump()):
		velocity += get_wall_normal() * _jump_velocity
		velocity.y += _jump_velocity
		_current_coyote_time = -1.0
		_current_jump_buffer_time = 0.0
		_current_wall_jumps += 1
		jumped = true
	elif (_wants_to_jump and (!is_on_floor() and !is_on_wall())):
		_current_jump_buffer_time = _jump_buffering_time
	
	_wants_to_jump = false
	move_and_slide()


func _input(event: InputEvent) -> void:
	var sensitivity: float
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		sensitivity = ProjectSettings.get_setting(&"game/input/mouse_sensitivity", 1.0) as float
		var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
		rotation_velocity = Vector3(-mouse_event.relative.y, -mouse_event.relative.x, 0.0) * sensitivity
		control_rotation_velocity = Vector3(-mouse_event.relative.y, -mouse_event.relative.x, 0.0) * sensitivity
	sensitivity = ProjectSettings.get_setting(
		&"game/input/gamepad_sensitivity", 36.0) as float
	var input: Vector2 = Input.get_vector(&"gamepad_look_left", &"gamepad_look_rgt",
		&"gamepad_look_down", &"gamepad_look_up") * sensitivity
	rotation_velocity.x += input.y
	control_rotation_velocity.x += input.y
	rotation_velocity.y += input.x
	control_rotation_velocity.y += input.x


func _calculate_input() -> void:
	_wish_dir = Input.get_vector(&"move_lft", &"move_rgt", &"move_fwd", &"move_bwd")
	if (Input.is_action_just_pressed(&"jump")): _wants_to_jump = true


func _calculate_gravity() -> float:
	return _jump_gravity if velocity.y > 0.0 else _fall_gravity


func _update_jump(delta: float) -> void:
	if (!is_on_floor() and _current_coyote_time > 0.0):
		_current_coyote_time -= delta
		if (_current_coyote_time <= 0.0): _current_coyote_time = -1.0
	if (_current_jump_buffer_time > 0.0):
		_current_jump_buffer_time = maxf(_current_jump_buffer_time - delta, 0.0)


func _should_jump() -> bool:
	if (is_on_floor()): return _wants_to_jump or _current_jump_buffer_time > 0.0
	else: return _wants_to_jump and _current_coyote_time > 0.0


func _should_wall_jump() -> bool:
	if (is_on_wall() and velocity.y > min_wall_jump_vertical_speed and _current_wall_jumps < max_wall_jumps):
		return _wants_to_jump or _current_jump_buffer_time > 0.0
	return false
