extends Node2D

@onready var mister_kitty = get_node_or_null("/root/World-01/mister_kitty")
@export var follow_speed: float = 2.0
@export var offset: Vector2 = Vector2(-50, -30) # -X = atrás, -Y = acima
@onready var anim: AnimationPlayer = $anim
@onready var texture: Sprite2D = $texturesun

@export var follow_player = false
var is_area_sun = false
var is_interacting = false

func _ready() -> void:
	anim.play("raio")

func _process(delta):
	# Se está na área e ainda não interagiu, mostra a textura
	if is_area_sun and !is_interacting:
		texture.show()
	else:
		texture.hide()
	
	# Se o player apertar para interagir dentro da área e ainda não está seguindo
	if Input.is_action_just_pressed("interact") and is_area_sun and !is_interacting:
		follow_player = true
		is_interacting = true
		texture.hide()

	# Se deve seguir o player
	if follow_player and mister_kitty:
		var target_position = mister_kitty.position + offset
		position = position.lerp(target_position, follow_speed * delta)

func _on_area_sun_body_entered(body: Node2D) -> void:
	if body.name == "mister_kitty":
		is_area_sun = true
		print("Entrou na área do sol")

func _on_area_sun_body_exited(body: Node2D) -> void:
	if body.name == "mister_kitty":
		is_area_sun = false
		print("Saiu da área do sol")
