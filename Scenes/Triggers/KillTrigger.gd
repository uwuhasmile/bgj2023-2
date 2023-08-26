extends Area3D


@export var sound: AudioStream


func _ready() -> void:
	body_entered.connect(_body_entered)


func _body_entered(body: Node) -> void:
	if (not body is Player): return
	(body as Player).die()
	SoundManager.play(0, sound)


func _exit_tree() -> void:
	body_entered.disconnect(_body_entered)
