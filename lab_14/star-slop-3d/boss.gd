extends Node3D

enum State { IDLE, ATTACK, RETREAT, DEATH }
var current_state : State
var hp: int
@export var max_hp : int = 10
@export var bullet_scene: PackedScene
@export var explosion : PackedScene
@export var damage_phase_one : int = 1
@export var damage_phase_two : int = 2

# ZMIENNE ANIMACJI (zamiast magicznych liczb)
@export var attack_x_tilt : float = 6			## Jak bardzo odchyla się na osi X podczas ATTACK
@export var attack_anim_time : float = 4		## Łączny czas animacji ataku
@export var retreat_distance : float = 5		## Jak daleko na osi Z ucieka podczas RETREAT
@export var retreat_time : float = 1.5			## Czas oddalania się podczas RETREAT
@export var spawn_z : float = 5					## Wartość osi Z do której powinien przyjść boss przy spawnie
@export var spawn_y : float = 0					## Wartość osi Y do której powinien przyjść boss przy spawnie
@export var spawn_anim_time : float = 4			## Łączny czas intra przy spawnie w sekundach
@export var idle_delay : float = 2				## Czas oczekiwania między IDLE a ATTACK
@export var death_delay : float = 2				## Czas między wybuchem przy śmierci a sygnałem i queue_free

# Tu pozwoliłem sobie nie zmieniać na @export, bo jest to integralna część sceny bossa.
@onready var hitbox_collision_one : CollisionShape3D = $HitboxPhase1/CollisionShape3D
@onready var hitbox_collision_two : CollisionShape3D = $HitboxPhase2/CollisionShape3D
@onready var shooting : Enemy_shooting_component = $Enemy_shooting_component

# Funkcja pomocnicza do tworzenia Tweenów
func _animate(property : NodePath, value : int, time : float) -> Tween:
	var tween = create_tween()
	tween.tween_property(self,property,value,time)
	return tween

func _ready() -> void:
	hp = max_hp
	# Zacznij niewidzialnym
	visible = false
	$HitboxPhase1.area_entered.connect(_on_hit_one)
	$HitboxPhase2.area_entered.connect(_on_hit_two)
	GameManager.spawn_boss.connect(_spawn)

# Rozwiązane w taki głupi sposób po trzeba przekazać Area3D inaczej jest krzyk
func _on_hit_one(_area: Area3D):
	take_hit(damage_phase_one)

func _on_hit_two(_area: Area3D):
	take_hit(damage_phase_two)


# Mechanika spawnowania (intro)
func _spawn() -> void:
	visible = true
	GameManager.setup_boss_bar.emit(max_hp)
	# Animacja podlatywania do przodu zza kamery (3/4 czasu) i w dół (1/4 czasu)
	await _animate("position:z",spawn_z,spawn_anim_time * 0.75).finished
	_animate("position:y",spawn_y,spawn_anim_time * 0.25)
	enterstate(State.IDLE)

func start_idle() -> void:
	# Na start hitbox jest wyłączony, żeby boss nie otrzymywał obrażeń w czasie trwania intro
	if hitbox_collision_one.disabled:
		hitbox_collision_one.disabled = false
	# Nic nie rób sekundy dwie
	await get_tree().create_timer(idle_delay).timeout
	enterstate(State.ATTACK)

func start_attack() -> void:
	shooting.shoot(bullet_scene,global_position)
	# Odchyla się (?) przez 37.5% czasu (1.5 sekundy dla 4 sekund)
	await _animate("position:x",position.x + attack_x_tilt/2,attack_anim_time * 0.375).finished
	# Od-odchyla się przez 37.5% czasu (1.5 sekundy dla 4 sekund)
	await _animate("position:x",position.x - attack_x_tilt,attack_anim_time * 0.375).finished
	# Powrót do pozycji początkowej przez 25% czasu (1 sekundę dla 4 sekund)
	await _animate("position:x",position.x + attack_x_tilt/2,attack_anim_time * 0.25).finished
	enterstate(State.RETREAT)
	
func start_retreat() -> void:
	# Oddala się na osi Z
	await _animate("position:z",position.z - retreat_distance,retreat_time).finished
	# Przy następnym retreat wraca (bo inaczej by się oddalał w nieskończoność, no jak to tak)
	retreat_distance *= -1
	enterstate(State.ATTACK)

func start_death() -> void:
	var boom = explosion.instantiate()
	get_tree().root.add_child(boom)
	boom.global_position = global_position
	await get_tree().create_timer(death_delay).timeout
	GameManager.boss_died.emit()
	queue_free()

func take_hit(damage) -> void:
	if current_state == State.DEATH:
		return
	print("Boss received " + str(damage) + " damage")
	hp = max(0,hp-damage)
	GameManager.boss_hp_changed.emit(hp)
	if hp <= 0:
		enterstate(State.DEATH)
	# Jeżeli hp <= max_hp/2 oraz nie jest jeszcze w fazie drugiej
	elif hp <= max_hp / 2.0 and hitbox_collision_two.disabled:
		hitbox_collision_two.disabled = false
		hitbox_collision_one.disabled = true

func enterstate(newstate : State) -> void:
	match newstate:
		State.IDLE:
			start_idle()
		State.ATTACK:
			start_attack()
		State.RETREAT:
			start_retreat()
		State.DEATH:
			start_death()
