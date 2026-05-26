## Statek

extends MeshInstance3D

@export var limit_x = 5
@export var limit_y = 3

@export var bullet_scene: PackedScene
var shoot_cooldown: float = 0.0
var roll_cooldown: float = 0.0
var bullets = []
const max_bullets = 3
const move_speed = 10
var is_invincible = false

func _clear_bullet(bullet) -> void:
	bullets.erase(bullet)

func _shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullets.append(bullet)
	get_tree().root.add_child(bullet)
	bullet.direction = Vector3(0,0,1)
	bullet.global_position = global_position
	shoot_cooldown = 0.3

func _take_damage() -> void:
	if not is_invincible:
		GameManager.player_hit(1)
	else:
		print("*Barrel Roll Dodge*")

func _do_barrel_roll() -> void:
	is_invincible = true
	$AnimationPlayer.play("barrel_roll")
	await $AnimationPlayer.animation_finished
	is_invincible = false
	roll_cooldown = 3

func _ready() -> void:
	GameManager.bullet_dead.connect(_clear_bullet)
	self.add_to_group("player")
	
	$Area3D.body_entered.connect(func(body): _take_damage())

func _process(delta: float) -> void:
	# Strzał
	if Input.is_action_pressed("ui_accept") and shoot_cooldown <= 0 and bullets.size() < max_bullets:
		_shoot()
	
	if Input.is_action_just_pressed("ui_select") and not is_invincible and roll_cooldown <= 0:
		_do_barrel_roll()
	
	# Ruch
	if Input.is_action_pressed("ui_left"):
		position.x -= move_speed * delta
	if Input.is_action_pressed("ui_right"):
		position.x += move_speed * delta
	if Input.is_action_pressed("ui_up"):
		position.y += move_speed * delta
	if Input.is_action_pressed("ui_down"):
		position.y -= move_speed * delta
	
	# Clamp pozycji
	position.x = clamp(position.x, -limit_x, limit_x)
	position.y = clamp(position.y, -limit_y, limit_y)
	
	# Cooldowny
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
	if roll_cooldown > 0:
		roll_cooldown -= delta
		
		
		
		
