extends Projectile

@export var stage : int = 0	# Bullet level (0-2)

func _ready() -> void:
	# Appropriate sprite from the atlas based on the level
	$Sprite2D.texture.region = Rect2(16 * stage,0,16,16)
