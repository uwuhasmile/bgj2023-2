extends Control
class_name MainMenu


signal started()

@export var time_label: Label
@export var deaths_label: Label


func _ready() -> void:
	if (is_instance_valid(time_label)):
		var time: float = GameSave.record_time
		if (time != -1.0):
			var minutes: float = time / 60.0
			var seconds: float = fmod(time, 60.0)
			var milliseconds: float = fmod(time, 1.0) * 100
			time_label.text = "Time elapsed: %02d:%02d:%02d" % [minutes, seconds, milliseconds]
		else:
			time_label.visible = false
	if (is_instance_valid(deaths_label)):
		var deaths: int = GameSave.record_deaths
		if (deaths > -1): deaths_label.text = "Record deaths: %d" % deaths
		else: deaths_label.visible = false


func start() -> void:
	started.emit()


func exit() -> void:
	get_tree().quit()
