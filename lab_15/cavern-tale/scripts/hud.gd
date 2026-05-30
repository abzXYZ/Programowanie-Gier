extends CanvasLayer

@onready var ammo_label : Label = get_node("Control/AmmoLabel")
@onready var lvl_bar : ProgressBar = get_node("Control/WpnLvlBar")
@onready var lvl_label : Label = get_node("Control/WpnLvlBar/WpnLvl")
@onready var hp_bar : ProgressBar = get_node("Control/HPBar")
@onready var hp_label : Label = get_node("Control/HPBar/HP")
@onready var wpn_icon : TextureRect = get_node("Control/WpnIcon")
@onready var fade : ColorRect = get_node("Control/Fade")

func _update_ammo(ammo : int, max_ammo : int) -> void:
	ammo_label.text = "AMMO " + str(ammo) + " / " + str(max_ammo)

func _update_wpn_lvl(lvl : float, max_lvl : float) -> void:
	# Set progress bar's max value as next level
	lvl_bar.max_value = min(ceil(lvl),max_lvl)
	lvl_bar.value = lvl
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

func transition(fadein : bool = true) -> void:
	var tween = create_tween()
	var goal = 1
	if fadein:
		goal = 0
	tween.tween_property(fade, "modulate:a", goal, 0.3)
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
	SignalBus.room_transition_started.connect(fade_out)
	SignalBus.room_transition_finished.connect(fade_in)
	# Prepare HP values (it doesn't work otherwise)
	_update_hp(%Player.hp,%Player.max_hp)
	visible = true
