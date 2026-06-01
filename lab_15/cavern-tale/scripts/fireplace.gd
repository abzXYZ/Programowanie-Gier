extends Interactable

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var burning : bool = false

func _ready() -> void:
	if burning:
		sprite.play("fire")

func interact() -> void:
	if not burning:
		burning = true
		sprite.play("fire")
		SignalBus.fireplace_lit.emit()
