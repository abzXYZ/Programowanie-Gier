## Statek

extends MeshInstance3D

@export var limit_x = 5
@export var limit_y = 3

@export var bullet_scene: PackedScene
var shoot_cooldown: float = 0.0
var bullets = []
const max_bullets = 3
const move_speed = 10

func clear_bullet(bullet) -> void:
	bullets.erase(bullet)

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullets.append(bullet)
	get_tree().root.add_child(bullet)
	bullet.direction = Vector3(0,0,1)
	bullet.global_position = global_position
	shoot_cooldown = 0.3

func _ready() -> void:
	SignalBus.bullet_dead.connect(clear_bullet)
	self.add_to_group("player")

func _process(delta: float) -> void:
	# Strzał
	if Input.is_action_pressed("ui_accept") and shoot_cooldown <= 0 and bullets.size() < max_bullets:
		shoot()
	
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
	
	# Cooldown strzału
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
