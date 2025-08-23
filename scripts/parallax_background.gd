extends ParallaxBackground

func _process(delta):
	var cam = get_viewport().get_camera_2d()
	if cam:
		scroll_offset = -cam.position * Vector2(0.5, 0.5)  # 0.5 = fondo más lejano
