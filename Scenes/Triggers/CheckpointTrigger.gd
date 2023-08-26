extends Area3D


@export var checkpoint: Checkpoint
@export var sound: AudioStream


func _ready() -> void:
	body_entered.connect(_body_entered)


func _body_entered(body: Node) -> void:
	if (not body is Player): return
	if (checkpoint.is_current()): return
	checkpoint.set_current()
	var player: Player = body as Player
	if (is_instance_valid(player.post_processing)):
		player.post_processing.flash_vignette(0, Color(1.0, 1.0, 0.0), 0.6, 0.4)
	if (is_instance_valid(player.hud)):
		player.hud.flash_text("CHECKPOINT", 0.8)
	SoundManager.play(0, sound)


func _exit_tree() -> void:
	body_entered.disconnect(_body_entered)
