extends Projectile

@export var stage : int = 0	# Bullet level (0-2)

@onready var sprite = $Sprite2D
@export var particle : PackedScene

func _impact_particle() -> void:
	var part = particle.instantiate()
	part.anim = "impact"
	get_tree().root.add_child(part)
	part.global_position = global_position

func _on_terrain_hit() -> void:
	_impact_particle()
	super()

func _ready() -> void:
	# Appropriate sprite from the atlas based on the level
	sprite.texture.region = Rect2(16 * stage,0,16,16)
	sprite.flip_h = direction.x > 0
	if direction.y != 0:
		sprite.rotation_degrees = 90 * -direction.y
