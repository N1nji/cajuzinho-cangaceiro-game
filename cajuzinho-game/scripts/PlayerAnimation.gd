extends Node
class_name PlayerAnimation

var player: CharacterBody2D
var anim: AnimatedSprite2D

func init(p, a):
	player = p
	anim = a

func update(delta):
	var state = "idle"

	if player.is_dead:
		state = "death"
	elif not player.is_on_floor():
		if player.velocity.y > 0:
			state = "fall"
		else:
			state = "jump"
	elif Vector2(player.velocity.x, player.velocity.y).length() > 1:
		state = "run"

	if anim.animation != state:
		anim.play(state)
		
# PlayerAnimation.gd
func stop_all_actions():
	player.velocity = Vector2.ZERO
	if anim:
		anim.play("idle")
