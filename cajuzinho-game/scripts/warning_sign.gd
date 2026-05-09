extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area_sign: Area2D = $area_sign

var is_interacting := false
var can_advance_message := false

const lines : Array[String] = [
	"Olá, Mister!",
	"Que tal tentar usar suas habilidades de gato?",
	"Para superar grandes desafios..."
]


func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0 and !is_interacting:
		texture.show()
		if event.is_action_pressed("interact") or event.is_action_pressed("ui_touch"):
			print("chamando")
			texture.hide()
			is_interacting = true
			if !DialogManager.is_message_active:
				DialogManager.current_source_node = self
				DialogManager.start_message(global_position, lines)
				
			#else:
				#DialogManager._unhandled_input(event)  # 🔹 Chama direto para forçar a passagem de diálogo
				
						
	else:
		texture.hide()
		if DialogManager.dialog_box and DialogManager.dialog_box.has_method("queue"):
			DialogManager.dialog_box.queue()
			DialogManager.is_message_active = false
			

func _process(_delta):
	if is_interacting and !DialogManager.is_message_active:
		is_interacting = false  # Reseta para permitir novas interações
	


func _on_area_sign_body_exited(body: Node2D) -> void:
	print("saiu da area")
	can_advance_message = false
	is_interacting = false

	if DialogManager.dialog_box and is_instance_valid(DialogManager.dialog_box):
		DialogManager.dialog_box.queue_free()
		DialogManager.dialog_box = null

	DialogManager.is_message_active = false
	
