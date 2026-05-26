extends Node

var score : int = 0
var lives : int = 3
var player_max_hp : int = 5
var player_hp : int = 5
var enemies_count : int = 1

signal score_changed(newscore)
signal lives_changed(newlives)
signal hp_changed(newhp)
signal gameover()
signal level_complete()
signal enemy_killed(points)
signal player_damaged()

signal bullet_dead(bullet)

func addscore(points) -> void:
	score += points
	score_changed.emit(score)

func handle_enemy_kill(points) -> void:
	addscore(points)
	enemies_count -= 1
	if enemies_count <= 0:
		level_complete.emit()

func player_hit(damage = 1) -> void:
	player_hp -= damage
	hp_changed.emit(player_hp)
	player_damaged.emit()
	if player_hp <= 0:
		gameover.emit()
	
func reset() -> void:
	score = 0
	lives = 3
	player_max_hp = 5
	player_hp = player_max_hp
	
func _ready() -> void:
	enemy_killed.connect(handle_enemy_kill)
