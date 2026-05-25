extends Sprite2D
class_name Weapon

@export var projectile : PackedScene	# The projectile the weapon shall fire
var level : float = 0					# Weapon level (heat)
@export var cooldown : float			# Base firing cooldown time in seconds
var current_cooldown : float = 0		# Cooldown remaining after use

func use() -> void:
	pass
