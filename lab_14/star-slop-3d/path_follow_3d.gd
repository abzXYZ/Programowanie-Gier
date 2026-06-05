extends PathFollow3D

# Szybkość dostosowana, aby ścieżka (bez przyspieszenia) przemierzana była przez ~10-15s
@export var rail_speed: float = 0.075
# Oddzielone zmienne speed i rail_speed, aby można było resetować prędkość w zadaniu dodatkowym 2
var speed = rail_speed

@export var pass_time : float = 5

@export var HudRatio : Label #%HUD/L_top/RatioLabel
@export var HudSpeed : Label #%HUD/L_top/SpeedLabel
@export var HudTime : Label #%HUD/L_top/TimeLabel

var elapsed = 0

func reset() -> void:
	elapsed = 0
	speed = rail_speed
	# Poinformuj kamerę, żeby się nie wlokła, tylko wróciła na start 
	GameManager.rail_finished.emit()

func updateHud() -> void:
	if HudRatio:
		HudRatio.text = str("Progress Ratio: ", progress_ratio)
	if HudSpeed:
		HudSpeed.text = str("Speed: ", speed)
	if HudTime:
		HudTime.text = str("Time: ", elapsed)

func _process(delta: float) -> void:
	elapsed += delta
	progress_ratio += speed * delta
	
	if progress_ratio < 0.01:
		reset()
	elif elapsed < pass_time:
		speed += 0.01 * delta
	
	updateHud()
