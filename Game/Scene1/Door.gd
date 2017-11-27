extends Node2D

func appear():
	get_node("Area2D").set_layer_mask(1)

func start_dialog():
	get_parent().next_scene()