extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -180
const GRAVITY = 500
 
@onready var sprite = $AnimatedSprite2D

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

	# Sprite flip
	if direction != 0:
		sprite.flip_h = direction > 0

	# Sprite
	var up : String
	if Input.is_action_pressed("ui_up"):
		up = "_up"
	
	if not is_on_floor():
		if Input.is_action_pressed("ui_down"):
			up = "_down"
		sprite.play("jump" + up)
	elif direction != 0:
		sprite.play("run" + up)
	else:
		sprite.play("idle" + up)
		if Input.is_action_pressed("ui_down"):
			sprite.play("look_behind")

	move_and_slide()
