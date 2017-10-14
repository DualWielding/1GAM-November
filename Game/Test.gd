extends VBoxContainer

func _on_VBoxContainer_draw():
	for node in get_children():
		print("lolz")
		node.set_size(Vector2(node.get_size().x, 50))
