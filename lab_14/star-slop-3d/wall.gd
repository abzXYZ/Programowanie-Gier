extends StaticBody3D

var mesh : MeshInstance3D
var material : Material
var player : Node3D

func _ready() -> void:
	mesh = $MeshInstance3D
	material = mesh.get_active_material(0).duplicate()
	mesh.material_override = material
	
	var players = get_tree().get_nodes_in_group("player")
	if not players.is_empty():
		player = players[0]

func _process(delta: float) -> void:
	var dist_from_player = abs(player.global_position.x - global_position.x)
	material.albedo_color = Color(1.0, 0.0, 0.0, max(0, 0.2 - (dist_from_player/25)) )
