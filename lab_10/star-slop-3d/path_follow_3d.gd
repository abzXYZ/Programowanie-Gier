extends PathFollow3D

# Szybkość dostosowana, aby ścieżka (bez przyspieszenia) przemierzana była przez ~10-15s
@export var rail_speed: float = 0.075
# Oddzielone zmienne speed i rail_speed, aby można było resetować prędkość w zadaniu dodatkowym 2
var speed = rail_speed

@onready var HudRatio = %HUD/RatioLabel
@onready var HudSpeed = %HUD/SpeedLabel
@onready var HudTime = %HUD/TimeLabel

var elapsed = 0

func reset() -> void:
	elapsed = 0
	speed = rail_speed

func updateHud() -> void:
	if HudRatio:
		HudRatio.text = str("Progress Ratio: ", progress_ratio)
	if HudSpeed:
		HudSpeed.text = str("Speed: ", speed)
	if HudTime:
		HudTime.text = str("Time: ", elapsed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += delta
	progress_ratio += speed * delta
	
	if progress_ratio < 0.01:
		reset()
	elif elapsed < 5:
		speed += 0.01 * delta
	
	updateHud()
