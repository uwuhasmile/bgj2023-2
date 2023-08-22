extends AudioStreamPlayer3D


@export var streams: Array[AudioStream]


func _ready() -> void:
	play()
	assert(get_stream_playback() is AudioStreamPlaybackPolyphonic, "Set stream to AudioStreamPolyphonic")


func play_stream(id: int, from: float = 0.0) -> void:
	(get_stream_playback() as AudioStreamPlaybackPolyphonic).play_stream(streams[id], from)
