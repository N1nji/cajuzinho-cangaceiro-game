extends Area2D

@export var enemy_life := 2
@onready var anim := $"../anim"
var is_dead := false

func _on_body_entered(body: Node2D) -> void:
	if is_dead: 
		return
	
	if body is Player: # melhor que checar pelo nome
		# Verifica se o player veio por cima (pulo na cabeça)
		if body.global_position.y < global_position.y:
			body.velocity.y = -body.jump_velocity
			enemy_life -= 1
			if enemy_life < 0:
				is_dead = true
				anim.play("death")
				await anim.animation_finished
				queue_free()
			else:
				anim.play("hurt")
				await anim.animation_finished
				anim.play("walk")
		else:
			# Caso contrário, o Player toma dano/knockback
			var knockback = Vector2(
				(body.global_position.x - global_position.x) * 200, 
				-200
			)
			body.take_damage(knockback)
