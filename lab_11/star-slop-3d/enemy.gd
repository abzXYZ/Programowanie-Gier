extends Node3D

var flash_material = StandardMaterial3D.new()

@export var hp: int = 2
@export var score_value: int = 100
@export var sway_amplitude: float = 2
@export var sway_period: float = 2
@export var shoot_interval: float = 2.5
@export var bullet_scene: PackedScene

func _on_shoot_timer():
	var playergroup = get_tree().get_nodes_in_group("player")
	
	if playergroup.is_empty():
		return

	var player = playergroup[0]
	var direction = (player.global_position - global_position).normalized()

	var bullet = bullet_scene.instantiate()
	bullet.collision_layer = 8 # Layer 4
	bullet.collision_mask = 1 # Mask 1
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.look_at(player.global_position)
	bullet.rotation.z += 90
	bullet.rotation.y += 90
	bullet.rotation.x += 90
	bullet.direction = direction

func _set_timer():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = shoot_interval
	timer.autostart = true
	timer.timeout.connect(_on_shoot_timer)
	timer.start()

func _ready():
	$Area3D.area_entered.connect(_on_hit)
	
	var initial_x = position.x
	
	flash_material.albedo_color = Color.RED
	flash_material.emission_enabled = true
	flash_material.emission = Color.RED
	
	var tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:x", initial_x + sway_amplitude, sway_period / 2)
	tween.tween_property(self, "position:x", initial_x - sway_amplitude, sway_period / 2)
	
	_set_timer()

func _on_hit(_area: Area3D):
	hp -= 1
	if hp <= 0:
		SignalBus.died.emit(score_value)
		$MeshInstance3D.material_override = flash_material
		await get_tree().create_timer(0.1).timeout
		queue_free()
