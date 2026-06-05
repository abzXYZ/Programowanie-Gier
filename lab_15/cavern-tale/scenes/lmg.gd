extends Weapon

@onready var flash = $MuzzleFlash
var max_ammo : int = 50
var ammo : int = max_ammo
@export var ammo_regen_delay : float		# Delay before the ammo starts regenerating after use
var current_ammo_regen_delay : float = 0
@export var ammo_regen_speed : float		# Time to resupply a single bullet in seconds
var current_ammo_regen_cooldown : float = 0

func _ready() -> void:
	# Setup values (EXPORT SUCKS)
	ammo_regen_delay = 1
	ammo_regen_speed = 0.3
	# Hide muzzle flash altogether when no longer shooting
	flash.animation_finished.connect(flash.hide)

func _process(delta: float) -> void:
	super(delta)
	if current_ammo_regen_delay >= 0:
		current_ammo_regen_delay -= delta
	elif ammo < max_ammo:
		if current_ammo_regen_cooldown <= 0:
			ammo += 1
			SignalBus.ammo_changed.emit(ammo,max_ammo)
			current_ammo_regen_cooldown = ammo_regen_speed
		current_ammo_regen_cooldown -= delta

func use() -> void:
	current_cooldown = cooldown
	ammo -= 1
	SignalBus.ammo_changed.emit(ammo,max_ammo)
	current_ammo_regen_delay = ammo_regen_delay
	var proj = projectile.instantiate()
	proj.global_position = global_position
	proj.direction = %Player.aiming_direction
	proj.speed = 300
	proj.stage = floor(level)
	proj.lifetime = 0.5
	get_tree().root.add_child(proj)
	flash.visible = true
	flash.play()
