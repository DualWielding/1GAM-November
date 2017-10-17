extends "res://NPC.gd"

func init():
	set_name("Guard")
	unique_name = "First guard"
	base_looking_direction = "left"

func check_neutralized(old_state, new_state):
	if new_state == "neutralized":
		get_parent().get_node("Door").appear()
		fade()

# To override in order to say stuff
#func start_dialog():
#	pass