extends Camera2D

func _input(event):
	if Input.is_action_just_released("scroll_down"):
		change_zoom(0.1)
	if Input.is_action_just_released("scroll_up"):
		change_zoom(-0.1)
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_MIDDLE:
			position -= event.relative * zoom
	if Input.is_action_just_pressed("normal_zoom"):
		zoom = Vector2(0.8,0.8)

func change_zoom(value):
	if zoom.x + value <= 0.5:
		return
	zoom += Vector2(value, value)
