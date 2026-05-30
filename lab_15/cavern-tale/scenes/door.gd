extends Interactable

@export var next_room : PackedScene

func interact() -> void:
	RoomManager.enter_indoors(next_room)
