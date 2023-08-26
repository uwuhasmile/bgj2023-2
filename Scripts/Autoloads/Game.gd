extends Node


var current_session: GameSession


func _ready() -> void:
	current_session = null


func _process(delta: float) -> void:
	if (is_instance_valid(current_session) and current_session.running):
		current_session.update(delta)


func new_session() -> void:
	if (is_instance_valid(current_session)):
		current_session.free()
	current_session = GameSession.new()


func end_session() -> void:
	if (is_instance_valid(current_session)):
		GameSave.last_time = current_session.time_elapsed
		if (GameSave.record_time == -1.0 or
				current_session.time_elapsed < GameSave.record_time):
			GameSave.record_time = current_session.time_elapsed
		GameSave.last_deaths = current_session.deaths
		if (GameSave.record_deaths == -1 or
				current_session.deaths < GameSave.record_deaths):
			GameSave.record_deaths = current_session.deaths
		current_session.free()
		current_session = null
