extends Interactable

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var burning : bool = false

func _ready() -> void:
	if burning:
		sprite.play("fire")

func interact() -> void:
	if not burning:
		burning = true
		AudioManager.play("menu")
		sprite.play("fire")
		AudioManager.play("fireplace")
		await get_tree().create_timer(2.0).timeout
		SignalBus.end_demo.emit()
