extends Node2D

@onready var mister_kitty := $mister_kitty as CharacterBody2D
@onready var camera := $camera as Camera2D

func _physics_process(delta):
	pass

func _ready() -> void:
	mister_kitty.camera_controller.follow_camera(camera)
	#var transition_scene = preload("res://prefabs/respawn_fade.tscn").instantiate()
	#get_tree().root.add_child(transition_scene)
	#transition_scene.start_transition_in() # só entrada, não troca cena


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F11:
			DisplayServer.window_set_mode(
				DisplayServer.WINDOW_MODE_WINDOWED if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
				else DisplayServer.WINDOW_MODE_FULLSCREEN
			)
