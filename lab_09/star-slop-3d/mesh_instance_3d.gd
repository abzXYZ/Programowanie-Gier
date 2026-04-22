extends MeshInstance3D

@export var limit_x = 5
@export var limit_y = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		position.x -= 4 * delta
	if Input.is_action_pressed("ui_right"):
		position.x += 4 * delta
	if Input.is_action_pressed("ui_up"):
		position.y += 4 * delta
	if Input.is_action_pressed("ui_down"):
		position.y -= 4 * delta
	position.x = clamp(position.x, -limit_x, limit_x)
	position.y = clamp(position.y, -limit_y, limit_y)
