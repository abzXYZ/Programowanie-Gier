extends Node3D

@onready var HUD = %HUD
@onready var ScoreLabel = HUD.get_node("L_top/ScoreLabel")
@onready var HPbar = HUD.get_node("Mid_bottom/HPbar")
@onready var LivesLabel = HUD.get_node("R_top/LivesLabel")

func _update_score(score) -> void:
	ScoreLabel.text = "Wynik: " + str(score)

func _update_hp(hp) -> void:
	HPbar.value = hp

func _update_lives(lives) -> void:
	LivesLabel.text = "Życia: " + str(lives)

func _game_over_screen() -> void:
	get_tree().change_scene_to_file("res://game_over.tscn")

func _level_complete_screen() -> void:
	get_tree().change_scene_to_file("res://level_complete.tscn")

func _ready() -> void:
	HPbar.max_value = GameManager.player_max_hp
	_update_hp(GameManager.player_hp)
	_update_lives(GameManager.lives)
	GameManager.score_changed.connect(_update_score)
	GameManager.hp_changed.connect(_update_hp)
	GameManager.lives_changed.connect(_update_lives)
	GameManager.gameover.connect(_game_over_screen)
	GameManager.level_complete.connect(_level_complete_screen)
