extends Camera3D

@export var camera_target: Node3D
@export var lag_speed = 5

var shake_duration: float = 0.0
var shake_intensity: float = 0.0
var difference : Vector3

func start_shake(intensity: float = 3, duration: float = 0.3) -> void:
	shake_intensity = intensity
	shake_duration = duration

func _snap_to_ship() -> void:
	global_position = camera_target.global_position + difference

func _ready() -> void:
	GameManager.player_damaged.connect(start_shake)
	GameManager.rail_finished.connect(_snap_to_ship)

func _process(delta: float) -> void:
	var offset = Vector3(0,0,0)

	if shake_duration > 0.0:
		shake_duration -= delta
		var t = shake_duration / 0.3
		offset = Vector3(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * shake_intensity * t
	
	global_position = global_position.lerp(camera_target.global_position + offset, lag_speed * delta)
	# Niweluj lekką zcinkę gdy następuje teleportacja; zachowaj pęd
	difference = global_position - camera_target.global_position
	
