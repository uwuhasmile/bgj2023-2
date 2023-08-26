extends Control
class_name FinishScreen


signal restarted()
signal finished()

@export var time_label: Label
@export var deaths_label: Label
@export var new_record_label: Label


func _ready() -> void:
	var time: float = GameSave.last_time
	var deaths: int = GameSave.last_deaths
	if (is_instance_valid(time_label)):
		var minutes: float = time / 60.0
		var seconds: float = fmod(time, 60.0)
		var milliseconds: float = fmod(time, 1.0) * 100
		time_label.text = "Time: %02d:%02d:%02d" % [minutes, seconds, milliseconds]
	if (is_instance_valid(deaths_label)):
		deaths_label.text = "Deaths: %d" % deaths
	if (is_instance_valid(new_record_label)):
		new_record_label.visible = time <= GameSave.record_time and deaths <= GameSave.record_deaths


func _restarted() -> void:
	restarted.emit()


func _finished() -> void:
	finished.emit()
