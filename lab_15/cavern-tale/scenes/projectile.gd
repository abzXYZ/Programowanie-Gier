extends Area2D
class_name Projectile

var direction : Vector2
var lifetime : float = 1
@export var speed : float
@export var damage : int

func _process(delta: float) -> void:
	global_position.x += direction.x * speed * delta
	global_position.y += direction.y * speed * delta
	# Handle lifetime to limit distance and/or prevent infinite projectiles
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
