extends "res://NPC.gd"

func init():
	set_name("Alma")
	unique_name = "Alma"
	base_looking_direction = "up"

func on_state_change(old_state, new_state):
	if new_state == "out":
		fade()