extends Node2D

func _ready():
	# Triggers once the scene is fully loaded and enables us to
	# tie bodies to the player and create callbacks
	for body in get_tree().get_nodes_in_group("body"):
		body.connect("stop_dialog", Player, "check_cards_number")