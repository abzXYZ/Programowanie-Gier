extends CanvasLayer

@onready var ammo_label : Label = get_node("Control/AmmoLabel")

func _update_ammo(ammo : int, max_ammo : int) -> void:
	ammo_label.text = "AMMO " + str(ammo) + " / " + str(max_ammo)

func _ready() -> void:
	SignalBus.ammo_changed.connect(_update_ammo)
	visible = true
