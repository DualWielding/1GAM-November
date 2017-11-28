extends "res://NPC.gd"

func init():
	set_name(tr("WAITER"))
	unique_name = "Waiter"
	base_looking_direction = "down"

func on_state_change(old_state, new_state):
	if new_state == "out":
		fade()