extends Control

@onready var title = $Title
@onready var menu_btn = $MenuBtn
@onready var retry_btn = $Retry
@onready var bg = $bg
@onready var fade = $fade

const TITLES = [
	"Unlucky",
	"Unfortunate",
	"Way to go",
	"Hang in there!",
	"That must've hurt",
	"Three times the charm!",
	"That was something",
	"Try again?",
	"GAME OVER",
	"YOU DIED"
]

func _ready() -> void:
	# Initial state - black screen, UI hidden
	fade.modulate.a = 1.0
	title.modulate.a = 0.0
	retry_btn.modulate.a = 0.0
	menu_btn.modulate.a = 0.0
	# Random title from texts
	title.text = TITLES.pick_random()
	# Button disabled
	_disable_buttons()
	retry_btn.pressed.connect(_retry)
	menu_btn.pressed.connect(_back_to_menu)
	_play_intro()

func _disable_buttons() -> void:
	retry_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _fade_ui(fadein : bool = true) -> Tween:
	var goal = 1.0
	if not fadein:
		goal = 0
	var ui_reveal := create_tween().set_parallel(true)
	ui_reveal.tween_property(title, "modulate:a", goal, 1.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	ui_reveal.tween_property(retry_btn, "modulate:a", goal, 1.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_delay(0.4)
	ui_reveal.tween_property(menu_btn, "modulate:a", goal, 1.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_delay(0.4)
	return ui_reveal

func _handle_buttons(next_scene : String) -> void:
	_disable_buttons()
	AudioManager.play("menu")
	
	await _fade_ui(false).finished
	
	var fade_out := create_tween()
	fade_out.tween_property(fade, "modulate:a", 1.0, 1) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
	await fade_out.finished

	get_tree().change_scene_to_file(next_scene)

func _play_intro() -> void:
	# Brief pause
	await get_tree().create_timer(0.5).timeout
	# Fade in to black (2s)
	var fade_in := create_tween()
	fade_in.tween_property(fade, "modulate:a", 0.0, 2.0) \
	.set_ease(Tween.EASE_IN_OUT) \
	.set_trans(Tween.TRANS_CUBIC)
	await fade_in.finished
	
	await _fade_ui().finished

	retry_btn.move_to_front()
	menu_btn.move_to_front()
	menu_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	retry_btn.mouse_filter = Control.MOUSE_FILTER_STOP

func _back_to_menu() -> void:
	print("Back to menu button pressed")
	_handle_buttons("res://scenes/menu.tscn")
	
func _retry() -> void:
	print("Retry button pressed")
	_handle_buttons("res://scenes/main.tscn")
	
