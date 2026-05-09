extends Area2D

@export var main_camera_path: NodePath
@export var alt_camera_path: NodePath
@export var transition_time: float = 1.0
@export var player_path: NodePath

var main_camera: Camera2D
var alt_camera: Camera2D
var player: Node2D
var active_camera: Camera2D
var target: Node2D

func _ready():
	if main_camera_path != NodePath("") and alt_camera_path != NodePath("") and player_path != NodePath(""):
		main_camera = get_node(main_camera_path)
		alt_camera = get_node(alt_camera_path)
		player = get_node(player_path)
		active_camera = main_camera
	else:
		push_warning("Câmeras ou player não atribuídos no Inspector para " + str(name))

func _on_body_entered(body: Node2D) -> void:
	if body.name == "mister_kitty":
		_smooth_camera_switch(active_camera, alt_camera)
		active_camera = alt_camera

func _on_body_exited(body: Node2D) -> void:
	if body.name == "mister_kitty":
		_smooth_camera_switch(active_camera, main_camera)
		active_camera = main_camera
		
func _smooth_camera_switch(from_camera: Camera2D, to_camera: Camera2D):
	to_camera.global_position = from_camera.global_position
	to_camera.make_current()
	
	var tween = get_tree().create_tween()
	tween.tween_property(to_camera, "global_position", player.global_position, transition_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	# Define a câmera ativa e habilita o follow
	target = player

func _process(delta):
	if target and active_camera:
		active_camera.global_position = active_camera.global_position.lerp(target.global_position, 0.1)
