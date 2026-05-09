extends Node
class_name PlayerHealth

var player: CharacterBody2D
var heart_ui
var respawn_animation: AnimationPlayer

var life := 7
var is_hurted := false
var knockback_vector := Vector2.ZERO
var knockback_power := 20

func init(p, ui, respawn_anim):
	player = p
	heart_ui = ui
	respawn_animation = respawn_anim




func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if player.is_dead:
		return

	life -= 1
	heart_ui.lose_heart()

	if life <= 0:
		kill()
		return

	if knockback_force != Vector2.ZERO:
		player.velocity = knockback_force  # aplica o empurrão
		var knockback_tween = get_tree().create_tween()
		knockback_tween.tween_property(player, "velocity", Vector2.ZERO, duration)

	is_hurted = true
	await get_tree().create_timer(.3).timeout
	if is_instance_valid(player) and not player.is_dead:
		is_hurted = false


func kill():
	if player.is_dead:
		return

	player.is_dead = true
	player.velocity = Vector2.ZERO  # Desliga movimento
	player.set_physics_process(false) # Desliga gravidade e física
	player.anim.play("death")
	await player.anim.animation_finished

	respawn()

func respawn():
	player.global_position = get_node("/root/World-01/spawn_point").global_position
	heart_ui.reset_hearts()
	life = 7
	player.is_dead = false
	player.set_physics_process(true) # Reativa física
	
	
