extends Label

func _ready() -> void:
	text = "Wynik: " + str(GameManager.score)
