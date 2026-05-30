extends Enemy

func _ready() -> void:
	xp_awarded = 0.75
	max_hp = 20
	touch_damage = 2
	# Hitbox trigger
	area_entered.connect(_on_area_entered)
	$AnimatedSprite2D.play()
	super()

func take_damage(amount: int) -> void:
	AudioManager.play("impact")
	super(amount)

func _die() -> void:
	AudioManager.play("death")
	super()

func _on_area_entered(area: Node) -> void:
	if area is Projectile:
		take_damage(area.damage)
		area.die()
