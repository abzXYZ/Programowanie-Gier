extends Node

var _current_room : Node2D

func set_current_room(room : Node2D) -> void:
	_current_room = room

func enter_room(room_scene : PackedScene, entry_point : String = "SpawnPos") -> void:
	SignalBus.room_transition_started.emit()
	
	await SignalBus.hud_transition_finished

	# Swap the room
	if _current_room:
		_current_room.queue_free()
	
	_current_room = room_scene.instantiate()
	var entry_position = _current_room.get_node(entry_point).global_position
	SignalBus.room_transition_finished.emit(_current_room,entry_position)

	await SignalBus.hud_transition_finished
