extends AnimatedSprite2D

var loop : bool = false
var anim : String = "impact"

func set_particle(animname : String, pos : Vector2, once : bool = true) -> void:
	anim = animname
	loop = !once
	global_position = pos

func _ready() -> void:
	if !loop:
		animation_looped.connect(queue_free)
	play(anim)
