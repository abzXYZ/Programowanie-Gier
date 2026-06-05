extends Parallax2D

func _ready() -> void:
	SignalBus.blizzard_timer_changed.connect(_handle_temperature)
	modulate = Blizzard.color
	
func _handle_temperature() -> void:
	modulate = Blizzard.color
