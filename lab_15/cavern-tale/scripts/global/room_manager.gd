extends Node

var _main : Node
var _current_room : Node2D
var _hud : CanvasLayer
var _player : CharacterBody2D

func init(main: Node) -> void:
	_main = main
	_hud = _main.get_node("%HUD")
	_player = _main.get_node("%Player")

func enter_room(room_scene: PackedScene) -> void:
	# Temporarily disable player movement
	_player.set_physics_process(false)
	_player.set_process(false)
	
	await _hud.transition(true)

	# Swap the room
	if _current_room:
		_current_room.queue_free()
	
	_current_room = room_scene.instantiate()
	_main.add_child(_current_room)

	# Move the player to the spawn point
	_player.global_position = _current_room.get_node("SpawnPos").global_position

	# Re-enable player movement
	_player.set_physics_process(true)
	_player.set_process(true)

	await _hud.transition(false)
