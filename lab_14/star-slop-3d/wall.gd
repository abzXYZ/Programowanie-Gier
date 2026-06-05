extends StaticBody3D

@export var mesh : MeshInstance3D
var material : Material
var player : Node3D
const base_color_alpha = 0.2		## Bazowa alpha koloru ściany
const alpha_decrease_intensity = 25	## Intensywność zmiany alphy koloru ściany (dist_from_player/ N )

func _ready() -> void:
	material = mesh.get_active_material(0).duplicate()
	mesh.material_override = material
	
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		player = players[0]

func _process(_delta: float) -> void:
	var dist_from_player = abs(player.global_position.x - global_position.x)
	material.albedo_color = Color(1.0, 0.0, 0.0, max(0, base_color_alpha - (dist_from_player/alpha_decrease_intensity)) )
