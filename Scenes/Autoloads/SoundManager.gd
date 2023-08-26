extends Node


@export var channels: Array[int]
var _channels: Array[AudioStreamPlayer]


func _ready() -> void:
	for polyphony in channels:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = &"Sound"
		var stream: AudioStreamPolyphonic = AudioStreamPolyphonic.new()
		stream.polyphony = polyphony
		player.stream = stream
		_channels.push_front(player)
		add_child(player)
		player.play()


func play(channel: int, stream: AudioStream,
		volume_db: float = 0.0, pitch_scale: float = 1.0, from: float = 0.0) -> void:
	assert(channel > -1 and channel < _channels.size())
	var player: AudioStreamPlayer = _channels[channel]
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	(player.get_stream_playback() as AudioStreamPlaybackPolyphonic).play_stream(stream, from)


func stop(channel: int, stream: int) -> void:
	assert(channel > -1 and channel < _channels.size())
	var player: AudioStreamPlayer = _channels[channel]
	(player.get_stream_playback() as AudioStreamPlaybackPolyphonic).stop_stream(stream)
