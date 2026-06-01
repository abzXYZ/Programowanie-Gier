extends Node2D

@onready var _fade = %HUD.fade

func _ready() -> void:
	# Set up the RoomManager
	RoomManager.set_current_room($Room)
	SignalBus.room_transition_finished.connect(_add_room)
	SignalBus.player_died.connect(_outro)
	_intro()

func _add_room(room : Node2D,_entry_point : Vector2) -> void:
	add_child(room)
	
func _intro() -> void:
	_fade.modulate.a = 1.0
	%HUD.transition(true,1)

func _outro() -> void:
	%Player.move_to_front()
	%HUD.transition(true,0)
	# Player disappearing animation
	var tween = create_tween()
	tween.tween_property(%Player, "modulate:a", 1.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
