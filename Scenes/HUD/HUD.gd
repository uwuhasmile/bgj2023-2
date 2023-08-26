extends CanvasLayer
class_name HUD


@export var time_label: Label
@export var deaths_label: Label
@export var flash_label: Label

var _flash_time: float = 0.0


func _process(delta: float) -> void:
	if (is_instance_valid(Game.current_session) and Game.current_session.running):
		if (is_instance_valid(time_label)):
			time_label.visible = true
			var time: float = Game.current_session.time_elapsed
			var minutes: float = time / 60.0
			var seconds: float = fmod(time, 60.0)
			var milliseconds: float = fmod(time, 1.0) * 100
			time_label.text = "Time elapsed: %02d:%02d:%02d" % [minutes, seconds, milliseconds]
		if (is_instance_valid(deaths_label)):
			deaths_label.visible = true
			deaths_label.text = "Deaths: %d" % Game.current_session.deaths
	else:
		if (is_instance_valid(time_label)):
			time_label.visible = false
		if (is_instance_valid(deaths_label)):
			deaths_label.visible = false
	
	if (is_instance_valid(flash_label)):
		if (_flash_time > 0.0):
			_flash_time = maxf(_flash_time - delta, 0.0)
			flash_label.visible = true
		else: flash_label.visible = false


func flash_text(text: String, time: float, color: Color = Color.YELLOW) -> void:
	if (not is_instance_valid(flash_label)): return
	_flash_time = time
	flash_label.text = text
	flash_label.modulate = color
