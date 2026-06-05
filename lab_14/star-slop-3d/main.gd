extends Node3D

@export var HUD : CanvasLayer
@export var ScoreLabel : Label
@export var HPbar : ProgressBar
@export var LivesLabel : Label
@export var BossHPbar : ProgressBar
@export var BossHPlabel : Label
@export var BossGrnHpBarThreshold : float = 0.66	## Próg do którego pasek HP bossa jest zielony
@export var BossYlwHpBarThreshold : float = 0.33	## Próg do którego pasek HP bossa jest Żółty

var _boss_max_hp = 0

func _update_score(score) -> void:
	ScoreLabel.text = "Wynik: " + str(score)

func _update_hp(hp) -> void:
	HPbar.value = hp

func _update_lives(lives) -> void:
	LivesLabel.text = "Życia: " + str(lives)

func _update_boss_hp(hp) -> void:
	BossHPbar.value = hp
	BossHPlabel.text = "BOSS HP: " + str(hp) + "/" + str(_boss_max_hp)
	# Zmień kolor paska adekwatnie do HP bossa
	if hp >= _boss_max_hp * BossGrnHpBarThreshold:
		BossHPbar.modulate = Color.LAWN_GREEN
	elif hp >= _boss_max_hp * BossYlwHpBarThreshold:
		BossHPbar.modulate = Color.YELLOW
	else:
		BossHPbar.modulate = Color.RED

func _setup_boss_bar(maxhp) -> void:
	_boss_max_hp = maxhp
	BossHPbar.max_value = _boss_max_hp
	_update_boss_hp(_boss_max_hp)
	BossHPbar.visible = true
	BossHPlabel.visible = true

func _game_over_screen() -> void:
	get_tree().change_scene_to_file("res://game_over.tscn")

func _level_complete_screen() -> void:
	get_tree().change_scene_to_file("res://level_complete.tscn")

func _end_game() -> void:
	GameManager.level_complete.emit()

func _ready() -> void:
	HPbar.max_value = GameManager.player_max_hp
	_update_hp(GameManager.player_hp)
	_update_lives(GameManager.lives)
	GameManager.score_changed.connect(_update_score)
	GameManager.hp_changed.connect(_update_hp)
	GameManager.lives_changed.connect(_update_lives)
	GameManager.gameover.connect(_game_over_screen)
	GameManager.level_complete.connect(_level_complete_screen)
	GameManager.boss_died.connect(_end_game)
	GameManager.setup_boss_bar.connect(_setup_boss_bar)
	GameManager.boss_hp_changed.connect(_update_boss_hp)
	# Puść muzykę
	GameManager.stop_title_theme()
	GameManager.play_bgm()
