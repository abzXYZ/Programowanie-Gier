extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -180
const GRAVITY = 500
const INVULN_TIME = 1.5		# Invulnerability time after getting damaged in seconds
 
@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox

enum State { MOBILE, IMMOBILE, STOPPED }
var active_weapon : Weapon
var aiming_direction : Vector2
var can_use_wpn : bool
var no_ammo_warning : bool
var invuln : float

var current_state : State
var max_hp : int = 10
var hp : int

func _variables_setup() -> void:
	aiming_direction = Vector2(-1,0)
	can_use_wpn = true
	no_ammo_warning = false
	hp = max_hp
	invuln = 0
	current_state = State.MOBILE
	active_weapon = $LMG
	# Emit signals so that the HUD gets updated
	SignalBus.hp_changed.emit(hp,max_hp)

func _ready() -> void:
	SignalBus.room_transition_started.connect(freeze)
	SignalBus.room_transition_finished.connect(_room_transition_finished)
	hitbox.area_entered.connect(_hitbox_check)
	_variables_setup()

func freeze() -> void:
	print("Player immobilized")
	current_state = State.IMMOBILE

func resume_movement() -> void:
	print("Player movement resumed")
	current_state = State.MOBILE
	
func stop() -> void:
	print("Player STOPPED")
	current_state = State.STOPPED

# FINITE STATE MACHINE [!]
func _process(delta: float) -> void:
	match current_state:
		State.MOBILE:
			_mobile_state(delta)
		State.IMMOBILE:
			_immobile_state(delta)
		State.STOPPED:
			pass

func _mobile_state(delta : float) -> void:
	# Weapon firing
	if active_weapon:
		if can_use_wpn and active_weapon.ammo > 0 and active_weapon.current_cooldown <= 0:
			if Input.is_action_pressed("use"):
				active_weapon.use()
				# Reset "no ammo" warning when weapon is used successfully
				no_ammo_warning = false
		elif active_weapon.ammo <= 0 and not no_ammo_warning:
			no_ammo_warning = true
			AudioManager.play("no_ammo")
	_handle_ivuln_time(delta)
		
func _immobile_state(delta : float) -> void:
	_handle_ivuln_time(delta)

func _handle_ivuln_time(delta : float) -> void:
	if invuln > 0:
		invuln -= delta
	if invuln <= 0:
		sprite.modulate = Color(1, 1, 1)

# FINITE STATE MACHINE [!]
func _physics_process(delta: float) -> void:
	match current_state:
		State.MOBILE:
			# MOBILE = Can move, standard gameplay
			_mobile_state_physics(delta)
		State.IMMOBILE:
			# IMMOBILE = Cannot move, some outside forces apply
			_immobile_state_physics(delta)
		State.STOPPED:
			# STOPPED = Total halt, not even move_and_slide
			pass

func _mobile_state_physics(delta: float) -> void:
	_handle_gravity(delta)
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
			if Input.is_action_just_pressed("ui_down"):
				_try_interact()

	move_and_slide()

func _immobile_state_physics(delta : float) -> void:
	_handle_gravity(delta)
	# Falling sprite
	if not is_on_floor():
		sprite.play("jump")
	
	move_and_slide()
	
# Handle gravity and check if the player fell out of the map
func _handle_gravity(delta : float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if global_position.y >= 500:
		# Drain all hp and ignore invuln
		take_damage(hp,true)

func apply_push_force(force : Vector2) -> void:
	velocity += force
	print(velocity)
	move_and_slide()

func _apply_invuln(inv_time : float = INVULN_TIME) -> void:
	invuln = inv_time
	sprite.modulate = Color(0.685, 0.351, 0.234)

func _hitbox_check(area : Node) -> void:
	# Getting damaged by enemy - takes damage, applies invuln and brings weapon level down
	if area is Enemy:
		take_damage(area.touch_damage)

func _try_interact() -> void:
	# Checks for all objects within the interaction detector and calls interact() on the first one.
	for area in hitbox.get_overlapping_areas():
		if area is Interactable:
			area.interact()
			return

func _room_transition_finished(_room : Node2D, entry_point : Vector2) -> void:
	global_position = entry_point
	resume_movement()

func take_damage(amount : int, ignore_invuln : bool = false, invuln_time : float = INVULN_TIME) -> void:
	# Only take damage if not in the state of STOPPED + out of invuln or ignore_invuln is passed
	if not current_state == State.STOPPED and (ignore_invuln or invuln <= 0):
		hp = max(0, hp - amount)
		active_weapon.level_up(-1)
		SignalBus.hp_changed.emit(hp, max_hp)
		_apply_invuln(invuln_time)
	if hp <= 0:
		AudioManager.play("playerdeath")
		stop()
		SignalBus.player_died.emit()
