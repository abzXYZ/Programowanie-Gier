extends Interactable

# Path to the next room scene file accessible through the inspector.
@export_file("*.tscn") var next_room_path : String
@export var closed : bool = false
@onready var sprite : Sprite2D = $Sprite2D
@export var safehouse_entrance : bool = false

func _ready() -> void:
	if closed:
		sprite.region_rect.position.x = 16

func interact() -> void:
	if next_room_path.is_empty():
		push_error("⚠ NO NEXT ROOM PATH ASSIGNED TO DOOR!")
		return
	var next_room := load(next_room_path) as PackedScene
	if next_room == null:
		push_error("⚠ NO ROOM RESOURCE FOUND!")
		return
	RoomManager.set_safehouse_status(safehouse_entrance)
	RoomManager.enter_room(next_room)
