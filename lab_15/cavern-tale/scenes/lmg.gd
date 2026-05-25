extends Weapon

func _ready() -> void:
	# Set weapon's base cooldown
	cooldown = 0.1

func use() -> void:
	var proj = projectile.instantiate()
	proj.global_position = global_position
	proj.direction = Vector2(-1,0)
	proj.speed = 300
	proj.stage = floor(level)
	proj.lifetime = 0.5
	get_tree().root.add_child(proj)
