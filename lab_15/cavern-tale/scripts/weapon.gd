extends Sprite2D
class_name Weapon

@export var projectile : PackedScene	# The projectile the weapon shall fire
var level : float = 0					# Weapon level
@export var max_level : float			# Max weapon level
@export var cooldown : float			# Base firing cooldown time in seconds
var current_cooldown : float = 0		# Cooldown remaining after use
var wpn_icon_region : int = 0			# Region of the icon on atlas texture

func _process(delta: float) -> void:
	if current_cooldown > 0:
		current_cooldown -= delta

func _ready() -> void:
	SignalBus.enemy_killed.connect(level_up)
	# Emit signal so that the HUD gets updated
	SignalBus.wpn_level_changed.emit(level,max_level)
	SignalBus.change_wpn_icon.emit(wpn_icon_region)

func use() -> void:
	pass

func level_up(xp : float) -> void:
	# Only act upon level_up if level below max_level unless the xp is negative
	if level < max_level or xp < 0:
		# Play sound on LEVEL UP or LEVEL DOWN
		if floor(level+xp)>floor(level):
			AudioManager.play("heat_up")
		elif floor(level+xp)<floor(level):
			AudioManager.play("error")
		print("XP gained -> " + str(xp))
		# Don't go below 0 and above max_level
		level = clamp(level + xp, 0, max_level)
		print("Current level -> " + str(floor(level)) + " (" + str(level) + ")")
		SignalBus.wpn_level_changed.emit(level,max_level)
