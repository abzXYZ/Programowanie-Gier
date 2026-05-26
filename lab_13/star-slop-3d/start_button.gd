extends Button

func _start_game() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://main.tscn")

func _ready() -> void:
	pressed.connect(_start_game)
