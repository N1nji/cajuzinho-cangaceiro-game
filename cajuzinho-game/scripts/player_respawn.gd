extends Node
class_name PlayerRespawn

var player: CharacterBody2D
var respawn_animation: AnimationPlayer

func init(p, anim):
	player = p
	respawn_animation = anim

func respawn():
	player.input_enabled = false
	respawn_animation.play("animation_respawn_2")
	await respawn_animation.animation_finished
	player.global_position = get_node("/root/World-01/spawn_point").global_position
	player.input_enabled = true
