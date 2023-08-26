extends Node


signal executed()


func execute() -> void:
	executed.emit()
