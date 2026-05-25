extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -180
const GRAVITY = 500
 
@onready var sprite = $AnimatedSprite2D
var active_weapon : Weapon
var aiming_direction : Vector2
var can_use_wpn : bool = true

func _switch_weapon(weapon) -> void:
	active_weapon = weapon

func _ready() -> void:
	aiming_direction = Vector2(-1,0)
	_switch_weapon($LMG)

func _process(delta: float) -> void:
	# Weapon firing
	if active_weapon:
		if can_use_wpn and active_weapon.ammo > 0 and active_weapon.current_cooldown <= 0:
			if Input.is_action_pressed("use"):
				active_weapon.use()

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	# Sprite flip + Aiming direction
	if direction != 0:
		sprite.flip_h = direction > 0
	aiming_direction = Vector2(1 if sprite.flip_h else -1,0)

	# Sprite
	can_use_wpn = true
	var up : String = ""
	if Input.is_action_pressed("ui_up"):
		up = "_up"
		aiming_direction = Vector2(0,-1)
	
	if not is_on_floor():
		if Input.is_action_pressed("ui_down"):
			up = "_down"
			aiming_direction = Vector2(0,1)
		sprite.play("jump" + up)
	elif direction != 0:
		sprite.play("run" + up)
	else:
		sprite.play("idle" + up)
		if Input.is_action_pressed("ui_down"):
			can_use_wpn = false
			sprite.play("look_behind")

	move_and_slide()
