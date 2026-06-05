extends Node3D

@export var particle_lifetime : float = 0.8	## Czas między odtworzeniem particle a queue_Free 

func _ready() -> void:
	$GPUParticles3D.emitting = true
	await get_tree().create_timer(particle_lifetime).timeout
	queue_free()
