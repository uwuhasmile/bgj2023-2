extends Node

const SAVE_FILE: String = "user://LJCliffs.sav"

var last_time: float
var last_deaths: int
var record_time: float
var record_deaths: int


func _ready() -> void:
	last_time = -1.0
	last_deaths = -1
	if (FileAccess.file_exists(SAVE_FILE)):
		var save: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
		record_time = save.get_float()
		record_deaths = save.get_32()
		save.close()
	else:
		record_time = -1.0
		record_deaths = -1


func _exit_tree() -> void:
	var save: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	save.store_float(record_time)
	save.store_32(record_deaths)
	save.close()
