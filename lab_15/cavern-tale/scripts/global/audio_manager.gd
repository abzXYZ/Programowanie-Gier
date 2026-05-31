extends Node

var sounds : Dictionary = {}
const SFX := {
	"neo_lmg":			"res://assets/sounds/neo_lmg.wav",
	"heat_up":			"res://assets/sounds/heat_up.wav",
	"explosion":		"res://assets/sounds/explosion.wav",
	"jump":				"res://assets/sounds/jump.wav",
	"land":				"res://assets/sounds/land.wav",
	"menu":				"res://assets/sounds/menu.wav",
	"error":			"res://assets/sounds/error.wav",
	"no_ammo":			"res://assets/sounds/no_ammo.wav",
	"rl":				"res://assets/sounds/rl.wav",
	"shotgun":			"res://assets/sounds/shotgun.wav",
	"shotgun_reload":	"res://assets/sounds/shotgun_reload.wav",
	"impact":			"res://assets/sounds/impact.wav",
	"death":			"res://assets/sounds/death.wav",
	"playerdeath":		"res://assets/sounds/playerdeath.wav",
	"smoke":			"res://assets/sounds/smoke.wav",
	"fireplace":		"res://assets/sounds/fireplace.ogg"
}

const MUSIC := {
	"crackling":	"res://assets/sounds/music/crackling.ogg",
}


func play(audio_name: String, volume_db: float = 0.0) -> void:
	if sounds.has(audio_name):
		sounds[audio_name].volume_db = volume_db
		sounds[audio_name].play()
	else:
		push_warning("⚠ ERROR PLAYING SOUND " + audio_name)

func play_once(audio_name: String, volume_db: float = 0.0) -> void:
	if sounds.has(audio_name):
		if not sounds[audio_name].playing:
			play(audio_name,volume_db)
	else:
		push_warning("⚠ ERROR PLAYING SOUND " + audio_name)

func stop_audio(audio_name: String) -> void:
	if sounds.has(audio_name):
		sounds[audio_name].stop()
	else:
		push_warning("⚠ ERROR PLAYING SOUND " + audio_name)

func fade_out_audio(audio_name : String) -> void:
	if sounds.has(audio_name):
		var music_fade := create_tween()
		music_fade.tween_property(sounds[audio_name], "volume_db", -80.0, 1.5) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
		await music_fade.finished
		sounds[audio_name].stop()
	else:
		push_warning("⚠ ERROR FADING SOUND " + audio_name)

func _ready() -> void:
	for key in SFX:
		var player := AudioStreamPlayer.new()
		player.stream = load(SFX[key])
		add_child(player)
		sounds[key] = player
	for key in MUSIC:
		var player := AudioStreamPlayer.new()
		player.stream = load(MUSIC[key])
		add_child(player)
		sounds[key] = player
