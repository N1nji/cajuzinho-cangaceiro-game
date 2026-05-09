extends Area2D
class_name Hurtbox

signal damage_received(body: Node2D)

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") or body.is_in_group("hazards"):
		emit_signal("damage_received", body)
