extends Control

func _ready() -> void:
	# Puść muzykę
	GameManager.stop_bgm()
	GameManager.play_title_theme()
