extends CharacterBody2D
class_name Player

# Status geral
var input_enabled := true
var is_dead := false
var jump_velocity:
	get: return movement.jump_velocity


# Componentes
@onready var movement: PlayerMovement = $Movement
@onready var health: PlayerHealth = $Health
@onready var animation: PlayerAnimation = $Animation
@onready var combat: PlayerCombat = $Combat
@onready var camera_controller: PlayerCamera = $CameraController
@onready var respawn: PlayerRespawn = $Respawn
@onready var hurtbox: Hurtbox = $hurtbox

# Nós auxiliares
@onready var anim: AnimatedSprite2D = $anim
@onready var ray_left: RayCast2D = $ray_left
@onready var ray_right: RayCast2D = $ray_right
@onready var remote_transform: RemoteTransform2D = $remote
@onready var coyote_timer: Timer = $coyote_timer
@onready var heart_ui = get_tree().get_first_node_in_group("heart_ui")
@onready var respawn_animation: AnimationPlayer = $"../respawn_fade/respawn_animation"

func _ready():
	add_to_group("player")

	# Injeta dependências nos módulos
	movement.init(self, ray_left, ray_right, coyote_timer, anim)
	health.init(self, heart_ui, respawn_animation)
	animation.init(self, anim)
	combat.init(self)
	camera_controller.init(self, remote_transform)
	respawn.init(self, respawn_animation)
	hurtbox.damage_received.connect(_on_damage_received)
	
	
func _on_damage_received(body: Node2D):
	if is_dead:
		return
	
	if health.life <= 0:
		is_dead = true
		animation.play("death")
		await animation.animation_finished
		respawn_player()
		health.life = 7
	else:
		var knockback = Vector2((global_position.x - body.global_position.x) * health.knockback_power, -200)
		take_damage(knockback)

func _physics_process(delta):
	if is_dead or not input_enabled:
		return

	movement.update(delta)
	combat.update(delta)
	animation.update(delta)
	
	# Player.gd
func take_damage(knockback := Vector2.ZERO, duration := 0.25):
	health.take_damage(knockback, duration)

func kill():
	health.kill()

func respawn_player():
	respawn.respawn()

func stop_all_actions():
	animation.stop_all_actions()

# getter para jump_velocity
func get_jump_velocity():
	return movement.jump_velocity
