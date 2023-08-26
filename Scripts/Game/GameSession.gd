extends Object
class_name GameSession


var running: bool = true
var time_elapsed: float = 0.0
var deaths: int = 0


func update(delta: float) -> void:
	if (running):
		time_elapsed += delta


func add_death() -> void:
	if (running):
		deaths += 1
