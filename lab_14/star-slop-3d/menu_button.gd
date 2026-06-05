extends Button

func _return_to_menu() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func _ready() -> void:
	pressed.connect(_return_to_menu)
