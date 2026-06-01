extends Node

var current_room : Node2D
var is_in_safehouse : bool

func _ready() -> void:
	# Game starts in a safehouse
	is_in_safehouse = true
	#SignalBus.safehouse_status_changed.emit(is_in_safehouse)

func set_safehouse_status(safehouse : bool) -> void:
	is_in_safehouse = safehouse
	SignalBus.safehouse_status_changed.emit(safehouse)

func set_current_room(room : Node2D) -> void:
	current_room = room

func enter_room(room_scene : PackedScene, entry_point : String = "SpawnPos") -> void:
	SignalBus.room_transition_started.emit()
	
	await SignalBus.hud_transition_finished

	# Swap the room
	if current_room:
		current_room.queue_free()
	
	current_room = room_scene.instantiate()
	var entry_position = current_room.get_node(entry_point).global_position
	SignalBus.room_transition_finished.emit(current_room,entry_position)

	await SignalBus.hud_transition_finished
