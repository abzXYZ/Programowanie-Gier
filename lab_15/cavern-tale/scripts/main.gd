extends Node2D

func _ready() -> void:
	# Set up the RoomManager
	RoomManager.set_current_room($Room)
	SignalBus.room_transition_finished.connect(_add_room)

func _add_room(room : Node2D,_entry_point : Vector2) -> void:
	add_child(room)
