extends Node

var score : int = 0
var bestscore : int = 0
var lives : int = 3
var player_max_hp : int = 5
var player_hp : int = 5
var enemies_count : int = 1

var _sfx_score := AudioStreamPlayer.new()
var _sfx_hit := AudioStreamPlayer.new()
var _sfx_game_over := AudioStreamPlayer.new()
var _bgm := AudioStreamPlayer.new()
var _title_theme := AudioStreamPlayer.new()

signal score_changed(newscore)
signal lives_changed(newlives)
signal hp_changed(newhp)
signal gameover()
signal level_complete()
signal enemy_killed(points)
signal player_damaged()
signal bullet_dead(bullet)
signal boss_died()

# Odtwarzanie muzyki tła gry
func play_bgm() -> void:
	if not _bgm.playing:
		_bgm.play()

func stop_bgm() -> void:
	_bgm.stop()

# Odtwarzanie muzyki menu głównego
func play_title_theme() -> void:
	if not _title_theme.playing:
		_title_theme.play()

func stop_title_theme() -> void:
	_title_theme.stop()

func addscore(points) -> void:
	score += points
	score_changed.emit(score)

func handle_enemy_kill(points) -> void:
	addscore(points)
	_sfx_score.play()
	enemies_count -= 1
	if enemies_count <= 0:
		level_complete.emit()

func player_hit(damage = 1) -> void:
	player_hp -= damage
	hp_changed.emit(player_hp)
	player_damaged.emit()
	if player_hp <= 0:
		gameover.emit()
	
func _handle_game_over() -> void:
	if score > bestscore:
		bestscore = score
	_sfx_game_over.play()

func reset() -> void:
	score = 0
	lives = 3
	player_max_hp = 5
	player_hp = player_max_hp

func _init_audio() -> void:
	add_child(_sfx_score)
	add_child(_sfx_hit)
	add_child(_sfx_game_over)
	_sfx_score.stream = preload("res://assets/audio/hurt.wav")
	_sfx_hit.stream = preload("res://assets/audio/player_hurt.wav")
	_sfx_game_over.stream = preload("res://assets/audio/lost.wav")
	add_child(_bgm)
	_bgm.stream = preload("res://assets/audio/music.wav")
	_bgm.volume_db = -10
	add_child(_title_theme)
	_title_theme.stream = preload("res://assets/audio/theme.wav")
	
func _ready() -> void:
	_init_audio()
	enemy_killed.connect(handle_enemy_kill)
	player_damaged.connect(func(): _sfx_hit.play())
	gameover.connect(_handle_game_over)
