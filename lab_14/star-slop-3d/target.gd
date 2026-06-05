# SKRYPT ZE STARYCH LABÓW

extends Node3D

var flash_material = StandardMaterial3D.new()
const destroy_delay : float = 0.1

func _ready():
	$Area3D.area_entered.connect(_on_hit)
	
	flash_material.albedo_color = Color.RED
	flash_material.emission_enabled = true
	flash_material.emission = Color.RED

func _on_hit(_area: Area3D):
	GameManager.enemy_killed.emit(0)
	$MeshInstance3D.material_override = flash_material
	await get_tree().create_timer(destroy_delay).timeout
	queue_free()
