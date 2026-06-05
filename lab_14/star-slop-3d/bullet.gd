extends Area3D

@export var speed: float = 30.0
@export var lifetime: float = 2
@export var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		GameManager.bullet_dead.emit(self)
		queue_free()
