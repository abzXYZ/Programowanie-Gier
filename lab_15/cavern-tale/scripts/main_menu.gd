extends Control

@onready var title = $Title
@onready var button = $Start
@onready var tile = $TileContainer
@onready var bg = $bg
@onready var fade = $fade

func _ready() -> void:
	# Initial state - black screen, UI hidden
	fade.modulate.a = 1.0
	title.modulate.a = 0.0
	button.modulate.a = 0.0
	# Button disabled
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.pressed.connect(_begin)
	_play_intro()

func _fade_ui(fadein : bool = true) -> Tween:
	var goal = 1.0
	if not fadein:
		goal = 0
	var ui_reveal := create_tween().set_parallel(true)
	ui_reveal.tween_property(title, "modulate:a", goal, 1.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	ui_reveal.tween_property(button, "modulate:a", goal, 1.5) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_delay(0.4)
	return ui_reveal

func _play_intro() -> void:
	AudioManager.play("fireplace")
	
	# Brief pause
	await get_tree().create_timer(0.5).timeout
	# Fade in to black (2s)
	var fade_in := create_tween()
	fade_in.tween_property(fade, "modulate:a", 0.0, 2.0) \
	.set_ease(Tween.EASE_IN_OUT) \
	.set_trans(Tween.TRANS_CUBIC)
	await fade_in.finished

	# 1s break
	await get_tree().create_timer(1.0).timeout
	AudioManager.play("crackling")
	
	await _fade_ui().finished

	# Intro complete - go crazy
	button.move_to_front()
	button.mouse_filter = Control.MOUSE_FILTER_STOP

func _begin() -> void:
	print("Start button pressed")
	# Lock the button immediately so it can't be double pressed
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	AudioManager.play("menu")
	AudioManager.fade_out_audio("fireplace")
	AudioManager.fade_out_audio("crackling")
	
	await _fade_ui(false).finished
	
	tile.move_to_front()
	tile.get_node("AnimatedSprite2D").play("smoke")
	AudioManager.play("smoke")
	
	# Fade to black (covers bg, title, button — but not tile)
	var fade_out := create_tween()
	fade_out.tween_property(fade, "modulate:a", 1.0, 1.5) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
	await fade_out.finished

	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
