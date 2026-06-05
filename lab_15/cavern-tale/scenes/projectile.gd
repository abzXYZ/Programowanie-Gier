extends Area2D
class_name Projectile

var direction : Vector2
var lifetime : float = 1	# Time left to live before deletion in seconds
@export var speed : float
@export var damage : int

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_terrain_hit() -> void:
	lifetime = 0

func _on_body_entered(body: Node) -> void:
	if body is TileMapLayer:
		_on_terrain_hit()

func _process(delta: float) -> void:
	global_position.x += direction.x * speed * delta
	global_position.y += direction.y * speed * delta
	# Handle lifetime to limit distance and/or prevent infinite projectiles
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
