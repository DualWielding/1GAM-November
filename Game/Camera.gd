extends Camera2D

func _ready():
#	pass
	var size = OS.get_window_size()
	set_pos(Vector2(get_pos().x, (get_pos().y + size.y/2) - (size.y/3)*2))
