extends CharacterBody2D

@export_category("Dialog Settings")
@export var dialog_screen: PackedScene
@export var _hud: CanvasLayer

@onready var anim: AnimatedSprite2D = $anim
@onready var howl_area: Area2D = $howl_area

var current_dialog
var player_in_area := false
var dialog_started := false

@export var dialog_data_to_use: Dictionary = {
	0: {
		"title": "Coruja",
		"dialog": "Ei, olá gatinho!",
		"faceset": "res://dialog_screen_facesets/howl_profile.png"
	},
	1: {
		"title": "Coruja",
		"dialog": "Que tal usar as setinhas para se mover?",
		"faceset": "res://dialog_screen_facesets/howl_profile.png"
	},
	2: {
		"title": "Coruja",
		"dialog": "E espaço para pular?",
		"faceset": "res://dialog_screen_facesets/howl_profile.png"
	},
}

func _ready() -> void:
	anim.play("idle")

func _process(_delta: float) -> void:
	# Se o player está na área e aperta E para interagir
	if player_in_area and not dialog_started and Input.is_action_just_pressed("interact"):
		_start_tutorial()

func _start_tutorial():
	dialog_started = true
	anim.play("howl_head")
	
	# Espera a animação de cabeça terminar antes de loop
	await anim.animation_finished
	anim.play("howl_loop")
	
	_show_dialog(dialog_data_to_use)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.stop_all_actions()
		player.input_enabled = false

func _show_dialog(dialog_data: Dictionary) -> void:
	if dialog_data.is_empty():
		return
	
	for child in _hud.get_children():
		if child is dialogscreen:
			child.queue_free()
	
	current_dialog = dialog_screen.instantiate()
	current_dialog.data = dialog_data
	current_dialog.auto_advance = false # Player avança com Enter
	current_dialog.auto_delay = 0
	
	# Conecta para saber quando terminou
	current_dialog.connect("dialog_finished", Callable(self, "_on_dialog_finished"))
	
	_hud.add_child(current_dialog)

func _on_dialog_finished():
	# Quando diálogo terminar, volta para idle
	anim.play("howl_back")
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.input_enabled = true
	
	current_dialog = null

func _on_howl_area_body_entered(body: Node2D) -> void:
	if body.name == "mister_kitty":
		player_in_area = true
		anim.play("howl_wings")

func _on_howl_area_body_exited(body: Node2D) -> void:
	if body.name == "mister_kitty":
		player_in_area = false
		anim.play("howl_back")
		dialog_started = false
