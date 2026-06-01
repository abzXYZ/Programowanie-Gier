extends CanvasLayer

@onready var ammo_label : Label = get_node("Control/AmmoLabel")
@onready var lvl_bar : ProgressBar = get_node("Control/WpnLvlBar")
@onready var lvl_label : Label = get_node("Control/WpnLvlBar/WpnLvl")
@onready var hp_bar : ProgressBar = get_node("Control/HPBar")
@onready var hp_label : Label = get_node("Control/HPBar/HP")
@onready var wpn_icon : TextureRect = get_node("Control/WpnIcon")
@onready var fade : ColorRect = get_node("Control/Fade")
@onready var timer : TextureProgressBar = get_node("BlizzardTimer")
@onready var weather_icon : TextureRect = get_node("BlizzardTimer/WeatherIcon")

var reset_timer : bool		# Flag to set the initial blizzard time on next timer update

func _update_ammo(ammo : int, max_ammo : int) -> void:
	ammo_label.text = "AMMO " + str(ammo) + " / " + str(max_ammo)

func _update_wpn_lvl(lvl : float, max_lvl : float) -> void:
	lvl_bar.value = 1
	if lvl < max_lvl:
		lvl_bar.value = lvl - floor(lvl)
	# Display weapon level on the bar (display as int to cut the .0)
	var text = "LV " + str(int(floor(lvl) + 1))
	if lvl == max_lvl:
		text += " [MAX]"
	lvl_label.text = text

func _update_hp(hp : int, max_hp : int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hp_label.text = "HP " + str(hp) + "/" + str(max_hp)

func _change_wpn_icon(region_offset : int) -> void:
	wpn_icon.texture.region = Rect2(region_offset,0,64,64)

func _update_timer() -> void:
	var _color = Blizzard.color
	if Blizzard.time_left <= 0:
		_color = Color(0.776, 0.26, 0.307, 1.0)
	timer.modulate = _color
	if reset_timer:
		reset_timer = false
		timer.max_value = Blizzard.initial_time
		# Set sunny icon
		weather_icon.texture.region = Rect2(0,0,64,64)
	timer.value = Blizzard.time_left
	if Blizzard.time_left <= Blizzard.initial_time * 0.25:
		weather_icon.texture.region = Rect2(192,0,64,64)
	elif Blizzard.time_left <= Blizzard.initial_time * 0.5:
		weather_icon.texture.region = Rect2(128,0,64,64)
	elif Blizzard.time_left <= Blizzard.initial_time * 0.75:
		weather_icon.texture.region = Rect2(64,0,64,64)
	
func _hide_timer() -> void:
	await _timer_transition(true).finished
	reset_timer = true
	
func _switch_timer_visibility(safehouse : bool) -> void:
	if safehouse:
		_hide_timer()
	elif timer.modulate.a == 0:
		_timer_transition(false)
	
func _timer_transition(fadein : bool = true, time : float = 0.3) -> Tween:
	var tween = create_tween()
	var goal = 1
	if fadein:
		goal = 0
	tween.tween_property(timer, "modulate:a", goal, time)
	return tween
	

func transition(fadein : bool = true, time : float = 0.3) -> void:
	var tween = create_tween()
	var goal = 1
	if fadein:
		goal = 0
	tween.tween_property(fade, "modulate:a", goal, time)
	await tween.finished
	SignalBus.hud_transition_finished.emit()

func fade_out() -> void:
	transition(false)
	
func fade_in(_a,_b) -> void:
	transition(true)


func _ready() -> void:
	SignalBus.ammo_changed.connect(_update_ammo)
	SignalBus.wpn_level_changed.connect(_update_wpn_lvl)
	SignalBus.hp_changed.connect(_update_hp)
	SignalBus.change_wpn_icon.connect(_change_wpn_icon)
	SignalBus.player_died.connect(_hide_timer)
	SignalBus.safehouse_status_changed.connect(_switch_timer_visibility)
	SignalBus.blizzard_timer_changed.connect(_update_timer)
	SignalBus.room_transition_started.connect(fade_out)
	SignalBus.room_transition_finished.connect(fade_in)
	reset_timer = true
	timer.modulate.a = 0
	# Prepare HP values (it doesn't work otherwise)
	_update_hp(%Player.hp,%Player.max_hp)
	visible = true
