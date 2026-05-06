extends Node

var waves = [
	# Formacja V
	{"pos": [Vector2(-3.0, 0.0), Vector2(0.0, -3),  Vector2(3.0, 0.0)],  "z_offset": 12.0, "delay": 1.0 },
	{"pos": [Vector2(-3.0, 1.0), Vector2(0.0, 0.0),  Vector2(3.0, -1.0)], "z_offset": 24.0, "delay": 3.5 },
	{"pos": [Vector2(-3.0, -1.5), Vector2(0.0, 2.0), Vector2(3.0, 1.0)],  "z_offset": 36.0, "delay": 5.0 }
]
var time: float = 0.0
var enemy = preload("res://enemy.tscn")
 
func spawn_wave(wave):
	for pos in wave["pos"]:
		var badguy = enemy.instantiate()
		badguy.position = Vector3(pos.x, pos.y, wave["z_offset"])
		get_tree().root.add_child(badguy)

func delete_spawned_waves(list):
	for wave in list:
		waves.erase(wave)
		print("Deleted wave with delay: " , wave["delay"])

func _process(delta: float) -> void:
	time += delta
	
	var for_deletion = []
	for i in range(waves.size()):
		if time >= waves[i]["delay"]:
			spawn_wave(waves[i])
			for_deletion.append(waves[i])
	delete_spawned_waves(for_deletion)
	
	
