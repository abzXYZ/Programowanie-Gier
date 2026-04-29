extends Area3D

@export var speed: float = 30.0
@export var lifetime: float = 2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.z += speed * delta
	lifetime -= delta
	if lifetime <= 0:
		SignalBus.bullet_dead.emit(self)
		queue_free()
