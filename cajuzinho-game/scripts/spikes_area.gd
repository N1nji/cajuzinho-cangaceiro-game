extends Area2D

@onready var collision: CollisionPolygon2D = $collision
@onready var texture: Sprite2D = $texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "mister_kitty" and body.has_method("kill"):
		body.kill()
