extends Node3D

var flash_material = StandardMaterial3D.new()

func _ready():
	$Area3D.area_entered.connect(_on_hit)
	
	flash_material.albedo_color = Color.RED
	flash_material.emission_enabled = true
	flash_material.emission = Color.RED

func _on_hit(_area: Area3D):
	SignalBus.target_hit.emit()
	$MeshInstance3D.material_override = flash_material
	await get_tree().create_timer(0.1).timeout
	queue_free()
