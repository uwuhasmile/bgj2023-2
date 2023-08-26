extends CanvasLayer


signal game_started()
signal game_restarted()
signal game_finished()

@export var main_menu_scene: PackedScene
@export var finish_screen_scene: PackedScene

@export var finish_sound: AudioStream

var _main_menu: MainMenu
var _finish_screen: FinishScreen


func show_main_menu() -> void:
	if (is_instance_valid(_main_menu)): _main_menu.free()
	_main_menu = main_menu_scene.instantiate() as MainMenu
	_main_menu.started.connect(_game_started)
	add_child(_main_menu)


func hide_main_menu() -> void:
	if (is_instance_valid(_main_menu)): _main_menu.queue_free()


func show_finish_screen() -> void:
	if (is_instance_valid(_finish_screen)): _finish_screen.queue_free()
	_finish_screen = finish_screen_scene.instantiate() as FinishScreen
	_finish_screen.restarted.connect(_game_restarted)
	_finish_screen.finished.connect(_game_finished)
	add_child(_finish_screen)
	SoundManager.play(0, finish_sound)


func hide_finish_screen() -> void:
	if (is_instance_valid(_finish_screen)): _finish_screen.queue_free()


func _game_started() -> void:
	game_started.emit()


func _game_restarted() -> void:
	game_restarted.emit()


func _game_finished() -> void:
	game_finished.emit()


func _exit_tree() -> void:
	hide_main_menu()
	hide_finish_screen()
