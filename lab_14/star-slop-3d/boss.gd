extends Node3D

enum State { IDLE, ATTACK, RETREAT, DEATH }
var current_state : State
@export var bullet_scene: PackedScene

func _ready() -> void:
	current_state = State.IDLE

func start_idle() -> void:
	# Nic nie rób sekundy dwie
	await get_tree().create_timer(2)
	enterstate(State.ATTACK)

func start_attack() -> void:
	_shoot()
	var tween = create_tween()
	tween.tween_property(self,"rotation_degrees",45,3.0)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self,"rotation_degrees",0,1.0)
	await tween.finished
	enterstate(State.RETREAT)
	
func start_retreat() -> void:
	
	pass

func start_death() -> void:
	GameManager.boss_died.emit()
	pass

func take_hit(damage) -> void:
	pass

func enterstate(newstate : State) -> void:
	match newstate:
		State.IDLE:
			pass
		State.ATTACK:
			pass
		State.RETREAT:
			pass
		State.DEATH:
			start_death()

func _shoot() -> void:
	pass

func _process(delta: float) -> void:
	pass
