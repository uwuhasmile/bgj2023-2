extends Area3D


signal player_entered()
signal player_exited()


func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)


func _body_entered(body: Node) -> void:
	if (body is Player): player_entered.emit()


func _body_exited(body: Node) -> void:
	if (body is Player): player_exited.emit()


func _exit_tree() -> void:
	body_entered.disconnect(_body_entered)
	body_entered.disconnect(_body_exited)
