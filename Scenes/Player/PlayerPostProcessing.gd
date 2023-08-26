extends Node
class_name PlayerPostProcessing


@export var vignettes: Array[ColorRect]

var _vignette_tweens: Dictionary


func _ready() -> void:
	_vignette_tweens = Dictionary()


func flash_vignette(id: int, color: Color, from: float, time: float) -> void:
	assert(id < vignettes.size())
	if (_vignette_tweens.has(id) and (_vignette_tweens[id] as Tween).is_valid()):
		(_vignette_tweens[id] as Tween).kill()
	vignettes[0].material.set("shader_parameter/vignette_rgb", color)
	vignettes[0].material.set("shader_parameter/vignette_intensity", from)
	var tween: Tween = create_tween()
	tween.tween_property(vignettes[0].material, "shader_parameter/vignette_intensity", 0.0, time)
	_vignette_tweens[id] = tween
