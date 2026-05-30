extends Weapon

@onready var flash = $MuzzleFlash
var max_ammo : int = 30
var ammo : int
@export var ammo_regen_delay : float		# Delay before the ammo starts regenerating after use
var current_ammo_regen_delay : float = 0
@export var ammo_regen_speed : float		# Time to resupply a single bullet in seconds
var current_ammo_regen_cooldown : float = 0
var proj_damage = [3,5,7]
var proj_lifetime = [0.5,0.7,0.7]
var proj_speed = [300,325,350]
@export var push_force = -35				# Knockback force of lvl 3 movement ability

func _ready() -> void:
	super()
	ammo = max_ammo
	# Emit signal so that the HUD gets updated
	SignalBus.ammo_changed.emit(ammo,max_ammo)
	# Setup values (EXPORT SUCKS)
	ammo_regen_delay = 1
	ammo_regen_speed = 0.2
	max_level = 2
	wpn_icon_region = 0
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
	# Apply firing cooldown
	current_cooldown = cooldown
	ammo -= 1
	SignalBus.ammo_changed.emit(ammo,max_ammo)
	# Reset ammo regen delay
	current_ammo_regen_delay = ammo_regen_delay
	# Create bullet
	var proj = projectile.instantiate()
	proj.global_position = global_position
	proj.direction = %Player.aiming_direction
	proj.stage = floor(level)
	# The WEAPON controls the values, because the projectile *could* be reused
	proj.damage = proj_damage[floor(level)]
	proj.lifetime = proj_lifetime[floor(level)]
	proj.speed = proj_speed[floor(level)]
	get_tree().root.add_child(proj)
	# Level 3 Movement ability
	if level == max_level:
		var push = %Player.aiming_direction * push_force
		%Player.apply_push_force(push)
	# FX + SFX
	flash.visible = true
	flash.play()
	AudioManager.play("neo_lmg")
