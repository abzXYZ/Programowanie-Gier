extends Parallax2D

func _ready() -> void:
	modulate.a = 0
	z_index = 1
	SignalBus.blizzard_timer_changed.connect(_update_snow)
	SignalBus.safehouse_status_changed.connect(_hide_snow)
	
func _update_snow() -> void:
	modulate.a = 1 - (Blizzard.time_left / Blizzard.initial_time)

func _hide_snow(safehouse : bool) -> void:
	if safehouse:
		z_index = -3
