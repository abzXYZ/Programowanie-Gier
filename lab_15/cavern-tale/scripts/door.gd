extends Interactable

# Path to the next room scene file accessible through the inspector.
@export_file("*.tscn") var next_room_path : String

func interact() -> void:
	if next_room_path.is_empty():
		push_error("⚠ NO NEXT ROOM PATH ASSIGNED TO DOOR!")
		return
	var next_room := load(next_room_path) as PackedScene
	if next_room == null:
		push_error("⚠ NO ROOM RESOURCE FOUND!")
		return
	RoomManager.enter_room(next_room)
