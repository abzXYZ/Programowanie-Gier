extends Node
class_name Enemy_shooting_component


func shoot(bullet_scene : PackedScene, bulletpos : Vector3) -> void:
	var playergroup = get_tree().get_nodes_in_group("player")

	if playergroup.is_empty():
		return

	var player = playergroup[0]
	var direction = (player.global_position - bulletpos).normalized()
	var bullet = bullet_scene.instantiate()
	bullet.collision_layer = 8 # Layer 4
	bullet.collision_mask = 1 # Mask 1
	get_tree().root.add_child(bullet)
	bullet.global_position = bulletpos
	bullet.look_at(player.global_position)
	# Korekta rotacji
	bullet.rotation.z += 90
	bullet.rotation.y += 90
	bullet.rotation.x += 90
	bullet.direction = direction
