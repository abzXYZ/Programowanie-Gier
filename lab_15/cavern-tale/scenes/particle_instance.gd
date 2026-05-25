extends AnimatedSprite2D

var loop : bool = false
var anim : String = "impact"

func _ready() -> void:
	if !loop:
		animation_looped.connect(queue_free)
	play(anim)
