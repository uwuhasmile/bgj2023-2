extends Area3D


func _ready() -> void:
	body_entered.connect(_body_entered)


func _body_entered(body: Node) -> void:
	if (not body is Player): return


func _exit_tree() -> void:
	body_entered.disconnect(_body_entered)
