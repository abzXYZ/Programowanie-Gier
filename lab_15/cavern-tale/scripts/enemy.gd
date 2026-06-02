extends Area2D
class_name Enemy

var particle : PackedScene	# Particle instance (impact on hit/smoke on death)
var max_hp : int
var xp_awarded : float		# XP added to active weapon's lv after kill
var touch_damage : int		# Damage dealt to the player upon touch
var hp : int

func _ready() -> void:
	hp = max_hp

func _spawn_particle(particle_name : String) -> void:
	if particle:
		var fx = particle.instantiate()
		fx.set_particle(particle_name, global_position)
		get_tree().root.add_child(fx)

func _die() -> void:
	_spawn_particle("smoke")
	SignalBus.enemy_killed.emit(xp_awarded)
	queue_free()

func take_damage(amount: int) -> void:
	hp -= amount
	_spawn_particle("impact")
	if hp <= 0:
		_die()
