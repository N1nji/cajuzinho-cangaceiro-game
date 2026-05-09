extends CanvasLayer

@export var next_scene: String = ""
@onready var respawn: ColorRect = $respawn

# Entrada: 1 → 0 (não troca de cena)
func start_transition_in():
	var mat = respawn.material as ShaderMaterial
	mat.set_shader_parameter("progress", 1.0)
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/progress", 0.0, 2.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "_destroy_self"))

# Saída: 0 → 1 e troca cena
func start_transition_out(scene_path: String):
	next_scene = scene_path
	var mat = respawn.material as ShaderMaterial
	mat.set_shader_parameter("progress", 0.0)
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/progress", 1.0, 2.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "_on_transition_finished"))

func _destroy_self():
	queue_free()

func _on_transition_finished():
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)
