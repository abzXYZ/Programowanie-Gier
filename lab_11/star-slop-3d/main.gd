extends Node3D

@export var score = 0

func score_up(points) -> void:
	score += points
	print("SCORE: " , score)

func _ready() -> void:
	SignalBus.died.connect(score_up)
