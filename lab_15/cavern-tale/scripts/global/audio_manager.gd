extends Node

var sounds : Dictionary = {}

const SFX_DIR := "res://assets/sounds/"
var SFX := {}

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

# Function to scan assets/sounds directory for SFX
func _load_sfx_directory() -> void:
	var dir := DirAccess.open(SFX_DIR)
	if not dir:
		push_warning("⚠ COULD NOT OPEN SOUNDS DIRECTORY")
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		# Is it a file and not a subdirectory?
		if not dir.current_is_dir():
			# Only check proper audio files
			var ext := file_name.get_extension().to_lower()
			if ext in ["wav", "ogg", "mp3"]:
				# Extract only the filename, no extension
				var key := file_name.get_basename()
				var path := SFX_DIR + file_name
				SFX[key] = path
		file_name = dir.get_next()
	dir.list_dir_end()

func _ready() -> void:
	_load_sfx_directory()
	for key in SFX:
		var player := AudioStreamPlayer.new()
		player.stream = load(SFX[key])
		add_child(player)
		sounds[key] = player
