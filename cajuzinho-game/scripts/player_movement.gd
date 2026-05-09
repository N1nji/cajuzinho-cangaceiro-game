extends Node
class_name PlayerMovement

var player: CharacterBody2D
var ray_left: RayCast2D
var ray_right: RayCast2D
var coyote_timer: Timer

# Movimento
@export var speed := 200.0
@export var jump_height := 64
@export var max_time_to_peak := 0.4
@export var max_jumps := 2
var jumps_left := 0
var is_jumping := false

# Física
var jump_velocity: float
var gravity: float
var fall_gravity: float
var direction := 0
var last_direction := 0
var sprite: AnimatedSprite2D

# Wall
@export var wall_slide_speed := 50.0
@export var wall_jump_force := Vector2(250, -400)
var is_wall_sliding := false
var wall_direction := 0

# Jump buffer
var jump_buffer_time := 0.15
var jump_buffer_counter := 0.0


func init(p, left_ray, right_ray, coyote, s):
	player = p
	ray_left = left_ray
	ray_right = right_ray
	coyote_timer = coyote
	sprite = s

	jump_velocity = -((jump_height * 2) / max_time_to_peak)
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2
	jumps_left = max_jumps


func update(delta):
	if not player.input_enabled:
		player.velocity = Vector2.ZERO
		return

	# Buffer de pulo
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_counter = jump_buffer_time
	if jump_buffer_counter > 0:
		jump_buffer_counter -= delta

	# Estado de chão
	if player.is_on_floor():
		is_jumping = false
		jumps_left = max_jumps - 1
	elif not is_jumping and coyote_timer.is_stopped():
		coyote_timer.start()

	# Pulo
	if jump_buffer_counter > 0 and (player.is_on_floor() or coyote_timer.time_left > 0 or jumps_left > 0):
		player.velocity.y = jump_velocity
		is_jumping = true
		if not player.is_on_floor():
			jumps_left -= 1  # só gasta pulo extra no ar
		jump_buffer_counter = 0.0

	# Wall slide
	var touching_left = ray_left.is_colliding()
	var touching_right = ray_right.is_colliding()
	if (touching_left or touching_right) and not player.is_on_floor() and player.velocity.y > 0:
		start_wall_slide(touching_left, touching_right)
	elif is_wall_sliding and not (touching_left or touching_right):
		stop_wall_slide()
	if is_wall_sliding and Input.is_action_just_pressed("ui_accept"):
		#player.velocity = Vector2(wall_jump_force.x * wall_direction, wall_jump_force.y)
		stop_wall_slide()

	# Gravidade
	if player.velocity.y > 0 and not Input.is_action_pressed("ui_accept"):
		player.velocity.y += fall_gravity * delta
	else:
		player.velocity.y += gravity * delta

	# Movimento horizontal
	direction = Input.get_axis("ui_left", "ui_right")
	var accel = 0.2 if player.is_on_floor() else 0.08
	var decel = 0.4 if player.is_on_floor() else 0.2

	if direction != 0:
		if direction != last_direction and player.is_on_floor():
			last_direction = direction
		player.velocity.x = lerp(player.velocity.x, direction * speed, accel * delta * 20)
		sprite.flip_h = direction < 0
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, decel * delta * 20)

	player.move_and_slide()


func start_wall_slide(left, right):
	is_wall_sliding = true
	player.velocity.y = min(player.velocity.y, wall_slide_speed)
	wall_direction = 1 if left else -1


func stop_wall_slide():
	is_wall_sliding = false
	wall_direction = 0
