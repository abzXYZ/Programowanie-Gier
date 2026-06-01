extends Node

const MIN_TIME = 60.0			# Min blizzard countdown in seconds
const MAX_TIME = 90.0			# Max blizzard countdown in seconds
const DAMAGE_INTERVAL = 1.0		# Time between damage ticks in seconds
const DAMAGE : int = 1			# Damage taken per interval
const BASE_COLOR : Color = Color(0.694, 0.972, 0.839)		# Base color of the "temperature"
enum State { COUNTING, SAFEHOUSE, PLAYER_DEAD }

var time_left : float
var initial_time : float
var _time_since_last_dmg : float = DAMAGE_INTERVAL
var current_state : State
var color : Color

func begin_countdown() -> void:
	current_state = State.COUNTING
	# Reset current color
	color = BASE_COLOR
	# Random time before blizzard starts between MIN and MAX
	time_left = randf_range(MIN_TIME,MAX_TIME)
	initial_time = time_left
	# Reset damage interval variable
	_time_since_last_dmg = 0
	print("BLIZZARD COUNTDOWN BEGUN")

func _check_safehouse_status(is_in_safehouse : bool) -> void:
	if is_in_safehouse:
		print("BLIZZARD COUNTDOWN STOPPED")
		current_state = State.SAFEHOUSE
	elif current_state != State.COUNTING:
		begin_countdown()

func _player_died() -> void:
	current_state = State.PLAYER_DEAD

func _ready() -> void:
	# Game begins in a safehouse
	current_state = State.SAFEHOUSE
	color = BASE_COLOR
	SignalBus.player_died.connect(_player_died)
	SignalBus.safehouse_status_changed.connect(_check_safehouse_status)

# Finite State Machine [!]
func _process(delta: float) -> void:
	match current_state:
		State.COUNTING:
			_handle_countdown(delta)
		State.PLAYER_DEAD:
			pass
		State.SAFEHOUSE:
			pass

func _handle_countdown(delta : float) -> void:
	# Player still has time - update the countdown
	if time_left > 0:
		time_left -= delta
		SignalBus.blizzard_timer_changed.emit()
	# Player ran out of time - handle damage ticks
	elif _time_since_last_dmg > 0:
		_time_since_last_dmg -= delta
	else:
		_time_since_last_dmg = DAMAGE_INTERVAL
		SignalBus.blizzard_damage.emit(DAMAGE)
	_update_color()

func _update_color() -> void:
	if time_left > 0:
		var temperature = Blizzard.time_left / Blizzard.initial_time
		color.r = BASE_COLOR.r - (Blizzard.initial_time - Blizzard.time_left) * 0.01
		color.g = BASE_COLOR.g - (Blizzard.initial_time - Blizzard.time_left) * 0.01 * 0.5
		color.b = clamp(1-temperature,BASE_COLOR.b,1)
	else:
		color = Color(0.151, 0.385, 1.0, 1.0)
