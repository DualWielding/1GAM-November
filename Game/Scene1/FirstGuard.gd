extends "res://NPC.gd"

func init():
	set_name("Guard")
	unique_name = "First guard"
	base_looking_direction = "right"

func check_neutralized(old_state, new_state):
	if new_state == "neutralized":
		get_parent().get_node("Door").appear()
		fade()