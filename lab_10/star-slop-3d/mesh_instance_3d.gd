## Statek

extends MeshInstance3D

@export var limit_x = 5
@export var limit_y = 3

@export var bullet_scene: PackedScene
var shoot_cooldown: float = 0.0
var score = 0
var bullets = []
const max_bullets = 3

func score_up() -> void:
	score += 1
	print("SCORE: " , score)

func clear_bullet(bullet) -> void:
	bullets.erase(bullet)

func _ready() -> void:
	SignalBus.target_hit.connect(score_up)
	SignalBus.bullet_dead.connect(clear_bullet)

func _process(delta: float) -> void:
	# Strzał
	if Input.is_action_pressed("ui_accept") and shoot_cooldown <= 0 and bullets.size() < max_bullets:
		var bullet = bullet_scene.instantiate()
		bullets.append(bullet)
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		shoot_cooldown = 0.3
	
	# Ruch
	if Input.is_action_pressed("ui_left"):
		position.x -= 0.5
	if Input.is_action_pressed("ui_right"):
		position.x += 0.5
	if Input.is_action_pressed("ui_up"):
		position.y += 0.5
	if Input.is_action_pressed("ui_down"):
		position.y -= 0.5
	
	# Clamp pozycji
	position.x = clamp(position.x, -limit_x, limit_x)
	position.y = clamp(position.y, -limit_y, limit_y)
	
	# Cooldown strzału
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
