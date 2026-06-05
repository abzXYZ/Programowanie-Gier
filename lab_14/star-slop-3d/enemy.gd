extends Node3D

var flash_material = StandardMaterial3D.new()

@export var hp: int = 2
@export var score_value: int = 100
@export var sway_amplitude: float = 2
@export var sway_period: float = 2
@export var shoot_interval: float = 2.5
@export var death_delay : float = 0.1	## Czas między początkiem śmierci a queue_free
@export var bullet_scene: PackedScene
@onready var shooting : Enemy_shooting_component = $Enemy_shooting_component

func _on_shoot_timer():
	shooting.shoot(bullet_scene,global_position)

func _set_timer():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = shoot_interval
	timer.autostart = true
	timer.timeout.connect(_on_shoot_timer)
	timer.start()

func _ready():
	$Area3D.area_entered.connect(_on_hit)
	# Usuwaj po przegranej
	GameManager.gameover.connect(queue_free)
	
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
		# Enemy killed, bo dodana obsługa ilości przeciwników, co wymaga dedykowanej funkcji
		GameManager.enemy_killed.emit(score_value)
		$MeshInstance3D.material_override = flash_material
		await get_tree().create_timer(death_delay).timeout
		queue_free()
