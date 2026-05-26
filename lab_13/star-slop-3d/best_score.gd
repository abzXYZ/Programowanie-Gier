extends Label

func _ready() -> void:
	text = "Najlepszy wynik sesji: " + str(GameManager.bestscore)
