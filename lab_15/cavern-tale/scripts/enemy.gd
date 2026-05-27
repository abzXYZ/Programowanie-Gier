extends Area2D
class_name Enemy

@export var particle : PackedScene	# Particle instance (impact on hit/smoke on death)
@export var max_hp : int
@export var xp_awarded : float		# XP added to active weapon's lv after kill
var hp : int

func _ready() -> void:
	hp = max_hp

func _spawn_particle(name : String) -> void:
	if particle:
		var fx = particle.instantiate()
		fx.set_particle(name, global_position)
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
